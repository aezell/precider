defmodule PreciderWeb.PreChooserLive.Index do
  use PreciderWeb, :live_view

  alias Precider.Catalog

  # Make scoring functions public in test environment
  if Mix.env() == :test do
    def score_product_test(product, answers), do: score_product(product, answers)
    def normalize_scores_test(scored_products), do: normalize_scores(scored_products)

    def calculate_ingredient_diversity_bonus_test(product),
      do: calculate_ingredient_diversity_bonus(product)

    def adjust_score_for_caffeine_refined_test(score, product, tolerance),
      do: adjust_score_for_caffeine_refined(score, product, tolerance)

    def adjust_score_for_budget_integrated_test(score, product, budget, cost_preference),
      do: adjust_score_for_budget_integrated(score, product, budget, cost_preference)
  end

  # Wizard steps configuration
  @steps [
    %{
      id: 1,
      name: "experience",
      title: "Experience Level",
      description: "How familiar are you with pre-workout supplements?"
    },
    %{
      id: 2,
      name: "goals",
      title: "Fitness Goals",
      description: "What are your primary workout goals?"
    },
    %{
      id: 3,
      name: "caffeine",
      title: "Caffeine Tolerance",
      description: "How much caffeine can you handle?"
    },
    %{
      id: 4,
      name: "stimulants",
      title: "Stimulant Preference",
      description: "What type of stimulants do you prefer?"
    },
    %{
      id: 5,
      name: "budget",
      title: "Budget Range",
      description: "What's your budget for pre-workout?"
    },
    %{
      id: 6,
      name: "cost_preference",
      title: "Cost Preference",
      description: "What matters more to you when comparing costs?"
    },
    %{
      id: 7,
      name: "timing",
      title: "Workout Timing",
      description: "When do you usually work out?"
    }
  ]

  @impl true
  def mount(params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Pre-Workout Chooser")
      |> assign(:steps, @steps)
      |> assign(:current_step, 1)
      |> assign(:total_steps, length(@steps))
      |> assign(:answers, %{})
      |> assign(:loading, false)
      |> assign(:recommendations, [])
      |> assign(:show_results, false)
      |> assign(:selected_products, MapSet.new())
      |> assign(:ingredients, Catalog.list_ingredients())
      |> assign(:products, Catalog.list_products())

    # Check if we have encoded answers in the URL (results page)
    socket =
      case params["answers"] do
        nil ->
          socket

        encoded_answers ->
          case decode_answers(encoded_answers) do
            {:ok, answers} ->
              socket
              |> assign(:answers, answers)
              |> assign(:current_step, length(@steps))
              |> generate_recommendations_for_url()

            {:error, _} ->
              socket
          end
      end

    {:ok, socket}
  end

  @impl true
  def handle_event("next_step", params, socket) do
    current_step = socket.assigns.current_step
    answers = Map.merge(socket.assigns.answers, params)

    if current_step >= socket.assigns.total_steps do
      # Generate recommendations and navigate to results URL
      {:noreply,
       socket
       |> assign(:answers, answers)
       |> assign(:loading, true)
       |> generate_recommendations_with_navigation()}
    else
      {:noreply,
       socket
       |> assign(:current_step, current_step + 1)
       |> assign(:answers, answers)}
    end
  end

  @impl true
  def handle_event("prev_step", _params, socket) do
    current_step = max(1, socket.assigns.current_step - 1)
    {:noreply, assign(socket, :current_step, current_step)}
  end

  @impl true
  def handle_event("restart_wizard", _params, socket) do
    {:noreply,
     socket
     |> assign(:current_step, 1)
     |> assign(:answers, %{})
     |> assign(:show_results, false)
     |> assign(:recommendations, [])
     |> assign(:selected_products, MapSet.new())
     |> assign(:loading, false)}
  end

  @impl true
  def handle_event("goto_step", %{"step" => step_str}, socket) do
    step = String.to_integer(step_str)

    if step <= socket.assigns.current_step do
      {:noreply, assign(socket, :current_step, step)}
    else
      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("toggle_product", %{"product_id" => product_id}, socket) do
    product_id = String.to_integer(product_id)
    selected_products = socket.assigns.selected_products

    updated_selection =
      if MapSet.member?(selected_products, product_id) do
        MapSet.delete(selected_products, product_id)
      else
        MapSet.put(selected_products, product_id)
      end

    {:noreply, assign(socket, :selected_products, updated_selection)}
  end

  @impl true
  def handle_event("compare_selected", _params, socket) do
    selected_ids = MapSet.to_list(socket.assigns.selected_products)

    if length(selected_ids) >= 2 do
      {:noreply, push_navigate(socket, to: ~p"/compare?products=#{Enum.join(selected_ids, ",")}")}
    else
      {:noreply, socket}
    end
  end

  # Generate recommendations and navigate to results URL (used when quiz is completed)
  defp generate_recommendations_with_navigation(socket) do
    socket = generate_recommendations_internal(socket)

    encoded_answers = encode_answers(socket.assigns.answers)
    push_navigate(socket, to: ~p"/pre_chooser/results?answers=#{encoded_answers}")
  end

  # Generate recommendations without navigation (used when loading from URL)
  defp generate_recommendations_for_url(socket) do
    generate_recommendations_internal(socket)
  end

  # Internal function that does the actual recommendation generation
  defp generate_recommendations_internal(socket) do
    answers = socket.assigns.answers
    products = socket.assigns.products

    # Score each product based on user answers
    scored_products =
      products
      |> Enum.map(&score_product(&1, answers))
      # Remove products with 0 or negative scores
      |> Enum.reject(&(elem(&1, 1) <= 0.0))
      |> Enum.sort_by(&elem(&1, 1), :desc)
      |> Enum.take(5)
      |> normalize_scores()
      |> Enum.map(fn {product, score} ->
        %{product: product, score: score, reasons: generate_reasons(product, answers)}
      end)

    socket
    |> assign(:recommendations, scored_products)
    |> assign(:show_results, true)
    |> assign(:loading, false)
  end

  defp score_product(product, answers) do
    base_score = 50.0
    score = base_score

    # Experience level scoring
    score =
      case answers["experience"] do
        "beginner" -> adjust_score_for_beginner(score, product)
        "intermediate" -> score
        "advanced" -> adjust_score_for_advanced(score, product)
        _ -> score
      end

    # Goals scoring
    score =
      if answers["goals"],
        do: adjust_score_for_goals(score, product, answers["goals"]),
        else: score

    # Caffeine tolerance scoring with fine-tuning
    score =
      if answers["caffeine"],
        do: adjust_score_for_caffeine_refined(score, product, answers["caffeine"]),
        else: score

    # Budget scoring integrated into match calculation
    score =
      if answers["budget"],
        do:
          adjust_score_for_budget_integrated(
            score,
            product,
            answers["budget"],
            answers["cost_preference"] || "total_cost"
          ),
        else: score

    # Timing scoring
    score =
      if answers["timing"],
        do: adjust_score_for_timing(score, product, answers["timing"]),
        else: score

    # Ingredient diversity bonus
    score = score + calculate_ingredient_diversity_bonus(product)

    {product, min(100.0, max(0.0, score))}
  end

  defp adjust_score_for_beginner(score, product) do
    # Beginners should avoid high-stim products
    caffeine_amount = get_ingredient_amount_by_category(product, "energy")

    cond do
      caffeine_amount > 300 -> score - 15.0
      caffeine_amount > 200 -> score - 8.0
      caffeine_amount < 150 -> score + 5.0
      true -> score
    end
  end

  defp adjust_score_for_advanced(score, product) do
    # Advanced users might prefer higher doses
    total_ingredients = length(product.product_ingredients)
    if total_ingredients > 10, do: score + 8.0, else: score
  end

  defp adjust_score_for_goals(score, product, goals) when is_list(goals) do
    Enum.reduce(goals, score, fn goal, acc ->
      case goal do
        "energy" ->
          energy_amount = get_ingredient_amount_by_category(product, "energy")
          if energy_amount > 150, do: acc + 8.0, else: acc

        "focus" ->
          if has_ingredient_by_category(product, "focus"), do: acc + 6.0, else: acc

        "endurance" ->
          if has_ingredient_by_category(product, "endurance"), do: acc + 6.0, else: acc

        "strength" ->
          if has_ingredient_by_category(product, "strength"), do: acc + 6.0, else: acc

        "pump" ->
          if has_ingredient_by_category(product, "pump"), do: acc + 8.0, else: acc

        "fat_loss" ->
          if has_ingredient_by_category(product, "fat_loss"), do: acc + 10.0, else: acc

        _ ->
          acc
      end
    end)
  end

  defp adjust_score_for_goals(score, _product, _goals), do: score

  defp adjust_score_for_caffeine_refined(score, product, tolerance) do
    caffeine_amount = get_ingredient_amount_by_category(product, "energy")

    case tolerance do
      "none" ->
        if caffeine_amount == 0, do: score + 15.0, else: score - 25.0

      "low" ->
        cond do
          caffeine_amount == 0 ->
            score + 5.0

          caffeine_amount <= 150 ->
            # Optimal around 100mg, taper off toward 150mg boundary
            optimal_distance = abs(caffeine_amount - 100) / 50
            bonus = 10.0 * (1 - optimal_distance)
            score + max(bonus, 3.0)

          caffeine_amount <= 200 ->
            score + 1.0

          true ->
            score - 12.0
        end

      "medium" ->
        cond do
          caffeine_amount >= 150 && caffeine_amount <= 250 ->
            # Optimal around 200mg
            optimal_distance = abs(caffeine_amount - 200) / 50
            bonus = 12.0 * (1 - optimal_distance)
            score + max(bonus, 5.0)

          caffeine_amount > 300 ->
            score - 8.0

          caffeine_amount < 150 ->
            score - 3.0

          true ->
            score + 2.0
        end

      "high" ->
        cond do
          caffeine_amount >= 250 ->
            # Favor higher amounts, with peak around 300-350mg
            if caffeine_amount >= 300 do
              optimal_distance = abs(caffeine_amount - 325) / 75
              bonus = 15.0 * (1 - optimal_distance)
              score + max(bonus, 8.0)
            else
              score + 8.0
            end

          caffeine_amount < 150 ->
            score - 8.0

          true ->
            score
        end

      _ ->
        score
    end
  end

  defp adjust_score_for_budget_integrated(score, product, budget, cost_preference) do
    price = Decimal.to_float(product.price || Decimal.new(0))

    # Calculate cost per serving if preference is set and servings data is available
    cost_to_compare =
      case cost_preference do
        "cost_per_serving"
        when not is_nil(product.servings_per_container) and product.servings_per_container > 0 ->
          price / product.servings_per_container

        _ ->
          price
      end

    # Adjust thresholds based on cost preference
    {low_threshold, medium_threshold, high_threshold} =
      case cost_preference do
        # Per serving thresholds
        "cost_per_serving" -> {1.2, 2.0, 3.0}
        # Total cost thresholds
        _ -> {30, 45, 65}
      end

    # Base budget scoring
    budget_score =
      case budget do
        "low" ->
          cond do
            cost_to_compare <= low_threshold -> 12.0
            cost_to_compare <= medium_threshold -> 5.0 - (cost_to_compare - low_threshold) * 3.0
            true -> -15.0
          end

        "medium" ->
          cond do
            cost_to_compare <= low_threshold -> 5.0
            cost_to_compare <= medium_threshold -> 8.0
            cost_to_compare <= high_threshold -> 3.0
            true -> -8.0
          end

        "high" ->
          cond do
            cost_to_compare <= medium_threshold -> 2.0
            cost_to_compare <= high_threshold -> 5.0
            true -> 8.0
          end

        _ ->
          0.0
      end

    # Additional value scoring - better cost per serving gets bonus points
    value_bonus =
      case cost_preference do
        "cost_per_serving" when cost_to_compare > 0 ->
          # Reward products with better value (lower cost per serving)
          reference_cost =
            case budget do
              "low" -> 1.5
              "medium" -> 2.0
              "high" -> 2.5
              _ -> 2.0
            end

          if cost_to_compare < reference_cost do
            (reference_cost - cost_to_compare) * 5.0
          else
            0.0
          end

        _ ->
          0.0
      end

    score + budget_score + value_bonus
  end

  defp adjust_score_for_timing(score, product, timing) do
    caffeine_amount = get_ingredient_amount_by_category(product, "energy")

    case timing do
      "evening" ->
        if caffeine_amount > 100, do: score - 25.0, else: score + 10.0

      "morning" ->
        if caffeine_amount > 200, do: score + 10.0, else: score

      "afternoon" ->
        if caffeine_amount > 300, do: score - 10.0, else: score

      _ ->
        score
    end
  end

  defp get_ingredient_amount_by_category(product, category) do
    product.product_ingredients
    |> Enum.filter(fn pi -> pi.ingredient.category == category end)
    |> Enum.map(fn pi ->
      # Convert to mg for comparison
      case pi.dosage_unit do
        :mg -> Decimal.to_float(pi.dosage_amount)
        :g -> Decimal.to_float(pi.dosage_amount) * 1000
        :mcg -> Decimal.to_float(pi.dosage_amount) / 1000
      end
    end)
    |> Enum.sum()
  end

  defp has_ingredient_by_category(product, category) do
    Enum.any?(product.product_ingredients, fn pi -> pi.ingredient.category == category end)
  end

  defp generate_reasons(product, answers) do
    reasons = []

    # Add reasons based on goals
    reasons =
      if answers["goals"] do
        goal_reasons = generate_goal_reasons(product, answers["goals"])
        reasons ++ goal_reasons
      else
        reasons
      end

    # Add caffeine-related reasons
    reasons =
      if answers["caffeine"] do
        caffeine_reason = generate_caffeine_reason(product, answers["caffeine"])
        if caffeine_reason, do: [caffeine_reason | reasons], else: reasons
      else
        reasons
      end

    # Add budget reason
    reasons =
      if answers["budget"] do
        budget_reason =
          generate_budget_reason(
            product,
            answers["budget"],
            answers["cost_preference"] || "total_cost"
          )

        if budget_reason, do: [budget_reason | reasons], else: reasons
      else
        reasons
      end

    # Limit to 3 reasons
    Enum.take(reasons, 3)
  end

  defp generate_goal_reasons(product, goals) when is_list(goals) do
    Enum.reduce(goals, [], fn goal, acc ->
      case goal do
        "energy" ->
          energy_amount = get_ingredient_amount_by_category(product, "energy")

          if energy_amount > 150,
            do: ["High stimulant content (#{round(energy_amount)}mg) for sustained energy" | acc],
            else: acc

        "focus" ->
          if has_ingredient_by_category(product, "focus"),
            do: ["Contains focus-enhancing nootropics" | acc],
            else: acc

        "endurance" ->
          if has_ingredient_by_category(product, "endurance"),
            do: ["Contains endurance-supporting ingredients" | acc],
            else: acc

        "pump" ->
          if has_ingredient_by_category(product, "pump"),
            do: ["Contains pump-enhancing ingredients for better blood flow" | acc],
            else: acc

        "strength" ->
          if has_ingredient_by_category(product, "strength"),
            do: ["Contains strength-supporting ingredients like creatine" | acc],
            else: acc

        "fat_loss" ->
          if has_ingredient_by_category(product, "fat_loss"),
            do: ["Contains thermogenic ingredients to support fat burning" | acc],
            else: acc

        _ ->
          acc
      end
    end)
  end

  defp generate_goal_reasons(_product, _goals), do: []

  defp generate_caffeine_reason(product, tolerance) do
    caffeine_amount = get_ingredient_amount_by_category(product, "energy")

    case tolerance do
      "none" when caffeine_amount == 0 ->
        "Stimulant-free formula perfect for stimulant-sensitive users"

      "low" when caffeine_amount <= 150 ->
        "Moderate stimulant content (#{round(caffeine_amount)}mg) ideal for low tolerance"

      "high" when caffeine_amount >= 250 ->
        "High stimulant content (#{round(caffeine_amount)}mg) for maximum energy"

      _ ->
        nil
    end
  end

  defp generate_budget_reason(product, budget, cost_preference) do
    price = Decimal.to_float(product.price || Decimal.new(0))

    # Calculate cost per serving if preference is set and servings data is available
    cost_to_show =
      case cost_preference do
        "cost_per_serving"
        when not is_nil(product.servings_per_container) and product.servings_per_container > 0 ->
          cost_per_serving = price / product.servings_per_container
          "#{format_money(cost_per_serving)} per serving"

        _ ->
          format_money(price)
      end

    case budget do
      "low" -> "Great value at #{cost_to_show}"
      "high" -> "Premium formula with advanced ingredients (#{cost_to_show})"
      _ -> nil
    end
  end

  defp step_completed?(assigns, step_id) do
    step_id < assigns.current_step ||
      (step_id == assigns.current_step && assigns.show_results)
  end

  defp calculate_ingredient_diversity_bonus(product) do
    # Reward products with diverse ingredient profiles
    categories =
      product.product_ingredients
      |> Enum.map(fn pi -> pi.ingredient.category end)
      |> Enum.uniq()
      |> length()

    # Bonus points for having ingredients from multiple categories
    case categories do
      n when n >= 5 -> 3.0
      n when n >= 4 -> 2.0
      n when n >= 3 -> 1.0
      _ -> 0.0
    end
  end

  defp normalize_scores(scored_products) when length(scored_products) <= 1, do: scored_products

  defp normalize_scores(scored_products) do
    scores = Enum.map(scored_products, fn {_product, score} -> score end)
    max_score = Enum.max(scores)
    min_score = Enum.min(scores)

    # If all scores are the same, create artificial distribution
    if max_score == min_score do
      scored_products
      |> Enum.with_index()
      |> Enum.map(fn {{product, _score}, index} ->
        # Create a gentle decline from 100% to ~85%
        normalized_score = 100.0 - index * 3.0
        {product, normalized_score}
      end)
    else
      # Scale scores so top product gets 100%, others distributed proportionally
      range = max_score - min_score

      Enum.map(scored_products, fn {product, score} ->
        # Scale to 85-100% range to ensure meaningful differences
        normalized_score = 85.0 + (score - min_score) / range * 15.0
        {product, Float.round(normalized_score, 1)}
      end)
    end
  end

  defp format_money(amount) when is_nil(amount), do: "N/A"

  defp format_money(amount) when is_float(amount) do
    # Use sprintf to ensure exactly 2 decimal places
    "$#{:io_lib.format("~.2f", [amount]) |> IO.iodata_to_binary()}"
  end

  defp format_money(decimal_amount) do
    amount = Decimal.to_float(decimal_amount)
    format_money(amount)
  end

  defp format_price(price) when is_nil(price), do: "N/A"

  defp format_price(price) do
    format_money(price)
  end

  defp format_cost_per_serving(product) do
    price = Decimal.to_float(product.price || Decimal.new(0))

    if not is_nil(product.servings_per_container) and product.servings_per_container > 0 do
      cost_per_serving = price / product.servings_per_container
      formatted_cost = format_money(cost_per_serving)
      "#{formatted_cost} per serving"
    else
      nil
    end
  end

  # URL encoding/decoding for answers
  defp encode_answers(answers) do
    answers
    |> Jason.encode!()
    |> Base.url_encode64(padding: false)
  end

  defp decode_answers(encoded) do
    try do
      decoded =
        encoded
        |> Base.url_decode64!(padding: false)
        |> Jason.decode!()

      {:ok, decoded}
    rescue
      _ -> {:error, :invalid_encoding}
    end
  end
end
