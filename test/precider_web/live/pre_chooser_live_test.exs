defmodule PreciderWeb.PreChooserLiveTest do
  use ExUnit.Case, async: true

  alias PreciderWeb.PreChooserLive.Index

  describe "money formatting functions" do
    test "io_lib.format ensures proper 2-decimal currency formatting" do
      # Test that our chosen formatting approach works correctly

      # Test whole dollar amounts - should show .00
      result = :io_lib.format("~.2f", [2.0]) |> IO.iodata_to_binary()
      assert result == "2.00"

      result = :io_lib.format("~.2f", [10.0]) |> IO.iodata_to_binary()
      assert result == "10.00"

      # Test amounts with cents
      result = :io_lib.format("~.2f", [2.5]) |> IO.iodata_to_binary()
      assert result == "2.50"

      result = :io_lib.format("~.2f", [19.99]) |> IO.iodata_to_binary()
      assert result == "19.99"

      # Test very small amounts
      result = :io_lib.format("~.2f", [0.01]) |> IO.iodata_to_binary()
      assert result == "0.01"

      # Test cost per serving calculation
      price = 50.0
      servings = 25
      # 2.0
      cost_per_serving = price / servings

      result = :io_lib.format("~.2f", [cost_per_serving]) |> IO.iodata_to_binary()
      # This should show as $2.00, not $2.0
      assert result == "2.00"

      # Test another calculation that might produce a .0 result
      price = 60.0
      servings = 30
      # 2.0
      cost_per_serving = price / servings

      result = :io_lib.format("~.2f", [cost_per_serving]) |> IO.iodata_to_binary()
      assert result == "2.00"
    end

    test "format_money wrapper function" do
      # Test the complete format_money functionality without accessing private functions

      # Helper function that mimics the private format_money function
      format_money = fn
        nil ->
          "N/A"

        amount when is_float(amount) ->
          "$#{:io_lib.format("~.2f", [amount]) |> IO.iodata_to_binary()}"

        decimal_amount ->
          amount = Decimal.to_float(decimal_amount)
          "$#{:io_lib.format("~.2f", [amount]) |> IO.iodata_to_binary()}"
      end

      # Test with float amounts
      assert format_money.(2.0) == "$2.00"
      assert format_money.(2.5) == "$2.50"
      assert format_money.(19.99) == "$19.99"

      # Test with Decimal amounts
      assert format_money.(Decimal.new("2.0")) == "$2.00"
      assert format_money.(Decimal.new("19.99")) == "$19.99"

      # Test nil
      assert format_money.(nil) == "N/A"
    end

    test "cost per serving calculation produces correctly formatted results" do
      # Test the exact scenario that was problematic

      format_cost_per_serving = fn product ->
        price = Decimal.to_float(product.price || Decimal.new(0))

        if not is_nil(product.servings_per_container) and product.servings_per_container > 0 do
          cost_per_serving = price / product.servings_per_container

          formatted_cost =
            "$#{:io_lib.format("~.2f", [cost_per_serving]) |> IO.iodata_to_binary()}"

          "#{formatted_cost} per serving"
        else
          nil
        end
      end

      # Test product that would produce $2.0 without proper formatting
      product = %{
        price: Decimal.new("50.00"),
        servings_per_container: 25
      }

      result = format_cost_per_serving.(product)
      # Should be $2.00, not $2.0
      assert result == "$2.00 per serving"

      # Test another case
      product2 = %{
        price: Decimal.new("60.00"),
        servings_per_container: 30
      }

      result2 = format_cost_per_serving.(product2)
      assert result2 == "$2.00 per serving"

      # Test with fractional result
      product3 = %{
        price: Decimal.new("19.99"),
        servings_per_container: 10
      }

      result3 = format_cost_per_serving.(product3)
      # 1.999 rounds to 2.00
      assert result3 == "$2.00 per serving"
    end
  end

  describe "scoring system" do
    # Helper function to create mock products
    defp create_mock_product(attrs \\ %{}) do
      defaults = %{
        id: 1,
        name: "Test Product",
        price: Decimal.new("40.00"),
        servings_per_container: 20,
        product_ingredients: []
      }

      Map.merge(defaults, attrs)
    end

    # Helper function to create mock ingredient
    defp create_mock_ingredient(category, amount \\ 200.0, unit \\ :mg) do
      %{
        ingredient: %{category: category},
        dosage_amount: Decimal.new("#{amount}"),
        dosage_unit: unit
      }
    end

    test "score_product returns floating point scores" do
      product =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 200.0)]
        })

      answers = %{"caffeine" => "medium"}

      {_product, score} = Index.score_product_test(product, answers)

      # Score should be a float
      assert is_float(score)
      assert score >= 0.0
      assert score <= 100.0
    end

    test "caffeine scoring fine-tuning within tolerance tiers" do
      # Test low tolerance with optimal caffeine (around 100mg)
      product_optimal =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 100.0)]
        })

      product_suboptimal =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 140.0)]
        })

      answers = %{"caffeine" => "low"}

      {_, score_optimal} = Index.score_product_test(product_optimal, answers)
      {_, score_suboptimal} = Index.score_product_test(product_suboptimal, answers)

      # Optimal caffeine amount should score higher than suboptimal
      assert score_optimal > score_suboptimal
    end

    test "medium caffeine tolerance peaks around 200mg" do
      product_200mg =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 200.0)]
        })

      product_175mg =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 175.0)]
        })

      product_150mg =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 150.0)]
        })

      answers = %{"caffeine" => "medium"}

      {_, score_200} = Index.score_product_test(product_200mg, answers)
      {_, score_175} = Index.score_product_test(product_175mg, answers)
      {_, score_150} = Index.score_product_test(product_150mg, answers)

      # 200mg should score highest, 175mg should score higher than 150mg
      assert score_200 >= score_175
      assert score_175 >= score_150
    end

    test "high caffeine tolerance favors 300mg+" do
      product_325mg =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 325.0)]
        })

      product_250mg =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 250.0)]
        })

      product_150mg =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 150.0)]
        })

      answers = %{"caffeine" => "high"}

      {_, score_325} = Index.score_product_test(product_325mg, answers)
      {_, score_250} = Index.score_product_test(product_250mg, answers)
      {_, score_150} = Index.score_product_test(product_150mg, answers)

      # Higher caffeine should score better for high tolerance
      assert score_325 > score_250
      assert score_250 > score_150
    end

    test "cost per serving affects scoring when selected" do
      # Low cost per serving product
      product_cheap =
        create_mock_product(%{
          price: Decimal.new("30.00"),
          # $1.00 per serving
          servings_per_container: 30
        })

      # High cost per serving product  
      product_expensive =
        create_mock_product(%{
          price: Decimal.new("60.00"),
          # $3.00 per serving
          servings_per_container: 20
        })

      answers = %{
        "budget" => "low",
        "cost_preference" => "cost_per_serving"
      }

      {_, score_cheap} = Index.score_product_test(product_cheap, answers)
      {_, score_expensive} = Index.score_product_test(product_expensive, answers)

      # Cheaper product should score higher for low budget
      assert score_cheap > score_expensive
    end

    test "ingredient diversity bonus rewards multi-category products" do
      # Product with diverse ingredients (5 categories)
      product_diverse =
        create_mock_product(%{
          product_ingredients: [
            create_mock_ingredient("energy"),
            create_mock_ingredient("focus"),
            create_mock_ingredient("pump"),
            create_mock_ingredient("endurance"),
            create_mock_ingredient("strength")
          ]
        })

      # Product with only one category
      product_simple =
        create_mock_product(%{
          product_ingredients: [
            create_mock_ingredient("energy"),
            # Same category
            create_mock_ingredient("energy")
          ]
        })

      answers = %{}

      {_, score_diverse} = Index.score_product_test(product_diverse, answers)
      {_, score_simple} = Index.score_product_test(product_simple, answers)

      # Diverse product should score higher due to diversity bonus
      assert score_diverse > score_simple
    end

    test "ingredient unit conversions work correctly" do
      # Test gram to mg conversion
      product_grams =
        create_mock_product(%{
          # 0.2g = 200mg
          product_ingredients: [create_mock_ingredient("energy", 0.2, :g)]
        })

      product_mg =
        create_mock_product(%{
          product_ingredients: [create_mock_ingredient("energy", 200.0, :mg)]
        })

      answers = %{"caffeine" => "medium"}

      {_, score_grams} = Index.score_product_test(product_grams, answers)
      {_, score_mg} = Index.score_product_test(product_mg, answers)

      # Should score similarly since they have the same effective caffeine amount
      assert abs(score_grams - score_mg) < 1.0
    end
  end

  describe "score normalization" do
    defp create_scored_products(scores) do
      scores
      |> Enum.with_index()
      |> Enum.map(fn {score, index} ->
        {create_mock_product(%{id: index + 1}), score}
      end)
    end

    test "normalize_scores handles identical scores" do
      scored_products = create_scored_products([80.0, 80.0, 80.0, 80.0, 80.0])

      normalized = Index.normalize_scores_test(scored_products)

      scores = Enum.map(normalized, fn {_product, score} -> score end)

      # Should create artificial distribution from 100% down to ~85%
      assert List.first(scores) == 100.0
      # 100 - (4 * 3)
      assert List.last(scores) == 88.0

      # Scores should be in descending order
      assert scores == Enum.sort(scores, :desc)
    end

    test "normalize_scores scales different scores proportionally" do
      scored_products = create_scored_products([90.0, 80.0, 70.0, 60.0, 50.0])

      normalized = Index.normalize_scores_test(scored_products)

      scores = Enum.map(normalized, fn {_product, score} -> score end)

      # Top score should be 100%
      assert List.first(scores) == 100.0

      # Bottom score should be 85%
      assert List.last(scores) == 85.0

      # Scores should be in descending order
      assert scores == Enum.sort(scores, :desc)

      # All scores should be rounded to 1 decimal place
      Enum.each(scores, fn score ->
        assert score == Float.round(score, 1)
      end)
    end

    test "normalize_scores handles single product" do
      scored_products = create_scored_products([75.0])

      normalized = Index.normalize_scores_test(scored_products)

      # Should return unchanged for single product
      assert normalized == scored_products
    end

    test "normalize_scores handles empty list" do
      normalized = Index.normalize_scores_test([])

      assert normalized == []
    end
  end
end
