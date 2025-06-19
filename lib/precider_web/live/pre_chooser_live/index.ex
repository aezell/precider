defmodule PreciderWeb.PreChooserLive.Index do
  use PreciderWeb, :live_view

  alias Precider.Catalog

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
      name: "timing",
      title: "Workout Timing",
      description: "When do you usually work out?"
    }
  ]

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Pre-Workout Chooser")
     |> assign(:steps, @steps)
     |> assign(:current_step, 1)
     |> assign(:total_steps, length(@steps))
     |> assign(:answers, %{})
     |> assign(:loading, false)
     |> assign(:recommendations, [])
     |> assign(:show_results, false)
     |> assign(:ingredients, Catalog.list_ingredients())
     |> assign(:products, Catalog.list_products())}
  end

  @impl true
  def handle_event("next_step", params, socket) do
    current_step = socket.assigns.current_step
    answers = Map.merge(socket.assigns.answers, params)

    if current_step >= socket.assigns.total_steps do
      # Generate recommendations
      {:noreply,
       socket
       |> assign(:answers, answers)
       |> assign(:loading, true)
       |> generate_recommendations()}
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

  defp generate_recommendations(socket) do
    answers = socket.assigns.answers
    products = socket.assigns.products

    # Score each product based on user answers
    scored_products =
      products
      |> Enum.map(&score_product(&1, answers))
      # Remove products with 0 or negative scores
      |> Enum.reject(&(elem(&1, 1) <= 0))
      |> Enum.sort_by(&elem(&1, 1), :desc)
      |> Enum.take(5)
      |> Enum.map(fn {product, score} ->
        %{product: product, score: score, reasons: generate_reasons(product, answers)}
      end)

    socket
    |> assign(:recommendations, scored_products)
    |> assign(:show_results, true)
    |> assign(:loading, false)
  end

  defp score_product(product, answers) do
    base_score = 50
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

    # Caffeine tolerance scoring
    score =
      if answers["caffeine"],
        do: adjust_score_for_caffeine(score, product, answers["caffeine"]),
        else: score

    # Budget scoring
    score =
      if answers["budget"],
        do: adjust_score_for_budget(score, product, answers["budget"]),
        else: score

    # Timing scoring
    score =
      if answers["timing"],
        do: adjust_score_for_timing(score, product, answers["timing"]),
        else: score

    {product, min(100, max(0, score))}
  end

  defp adjust_score_for_beginner(score, product) do
    # Beginners should avoid high-stim products
    caffeine_amount = get_ingredient_amount_by_category(product, "energy")

    cond do
      caffeine_amount > 300 -> score - 15
      caffeine_amount > 200 -> score - 8
      caffeine_amount < 150 -> score + 5
      true -> score
    end
  end

  defp adjust_score_for_advanced(score, product) do
    # Advanced users might prefer higher doses
    total_ingredients = length(product.product_ingredients)
    if total_ingredients > 10, do: score + 8, else: score
  end

  defp adjust_score_for_goals(score, product, goals) when is_list(goals) do
    Enum.reduce(goals, score, fn goal, acc ->
      case goal do
        "energy" ->
          energy_amount = get_ingredient_amount_by_category(product, "energy")
          if energy_amount > 150, do: acc + 8, else: acc

        "focus" ->
          if has_ingredient_by_category(product, "focus"), do: acc + 6, else: acc

        "endurance" ->
          if has_ingredient_by_category(product, "endurance"), do: acc + 6, else: acc

        "strength" ->
          if has_ingredient_by_category(product, "strength"), do: acc + 6, else: acc

        "pump" ->
          if has_ingredient_by_category(product, "pump"), do: acc + 8, else: acc

        "fat_loss" ->
          if has_ingredient_by_category(product, "fat_loss"), do: acc + 10, else: acc

        _ ->
          acc
      end
    end)
  end

  defp adjust_score_for_goals(score, _product, _goals), do: score

  defp adjust_score_for_caffeine(score, product, tolerance) do
    caffeine_amount = get_ingredient_amount_by_category(product, "energy")

    case tolerance do
      "none" ->
        if caffeine_amount == 0, do: score + 15, else: score - 25

      "low" ->
        cond do
          caffeine_amount == 0 -> score + 5
          caffeine_amount <= 150 -> score + 10
          caffeine_amount <= 200 -> score + 3
          true -> score - 10
        end

      "medium" ->
        cond do
          caffeine_amount >= 150 && caffeine_amount <= 250 -> score + 8
          caffeine_amount > 300 -> score - 5
          true -> score
        end

      "high" ->
        cond do
          caffeine_amount >= 250 -> score + 10
          caffeine_amount < 150 -> score - 5
          true -> score
        end

      _ ->
        score
    end
  end

  defp adjust_score_for_budget(score, product, budget) do
    price = Decimal.to_float(product.price || Decimal.new(0))

    case budget do
      "low" -> if price <= 35, do: score + 8, else: score - 10
      "medium" -> if price > 35 && price <= 50, do: score + 5, else: score - 3
      "high" -> if price > 50, do: score + 3, else: score
      _ -> score
    end
  end

  defp adjust_score_for_timing(score, product, timing) do
    caffeine_amount = get_ingredient_amount_by_category(product, "energy")

    case timing do
      "evening" ->
        if caffeine_amount > 100, do: score - 25, else: score + 10

      "morning" ->
        if caffeine_amount > 200, do: score + 10, else: score

      "afternoon" ->
        if caffeine_amount > 300, do: score - 10, else: score

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
        budget_reason = generate_budget_reason(product, answers["budget"])
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

  defp generate_budget_reason(product, budget) do
    price = Decimal.to_float(product.price || Decimal.new(0))

    case budget do
      "low" when price <= 35 -> "Great value at $#{:erlang.float_to_binary(price, decimals: 2)}"
      "high" when price > 50 -> "Premium formula with advanced ingredients"
      _ -> nil
    end
  end

  defp step_completed?(assigns, step_id) do
    step_id < assigns.current_step ||
      (step_id == assigns.current_step && assigns.show_results)
  end

  defp format_price(price) when is_nil(price), do: "N/A"

  defp format_price(price) do
    "$#{:erlang.float_to_binary(Decimal.to_float(price), decimals: 2)}"
  end
end
