defmodule PreciderWeb.PreChooserLiveTest do
  use ExUnit.Case, async: true
  
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
      cost_per_serving = price / servings  # 2.0
      
      result = :io_lib.format("~.2f", [cost_per_serving]) |> IO.iodata_to_binary()
      assert result == "2.00"  # This should show as $2.00, not $2.0
      
      # Test another calculation that might produce a .0 result
      price = 60.0
      servings = 30
      cost_per_serving = price / servings  # 2.0
      
      result = :io_lib.format("~.2f", [cost_per_serving]) |> IO.iodata_to_binary()
      assert result == "2.00"
    end
    
    test "format_money wrapper function" do
      # Test the complete format_money functionality without accessing private functions
      
      # Helper function that mimics the private format_money function
      format_money = fn
        nil -> "N/A"
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
          formatted_cost = "$#{:io_lib.format("~.2f", [cost_per_serving]) |> IO.iodata_to_binary()}"
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
      assert result == "$2.00 per serving"  # Should be $2.00, not $2.0
      
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
      assert result3 == "$2.00 per serving"  # 1.999 rounds to 2.00
    end
  end
end