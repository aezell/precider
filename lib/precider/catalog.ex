defmodule Precider.Catalog do
  @moduledoc """
  The Catalog context.
  """

  import Ecto.Query, warn: false
  import Ecto.Query.API, only: [fragment: 1], warn: false
  alias Precider.Repo

  alias Precider.Catalog.{Brand, Product, Ingredient, ProductIngredient}

  @doc """
  Returns the list of brands.

  ## Options

    * `:sort_by` - The field to sort by (default: :name)
    * `:sort_direction` - The direction to sort in (:asc or :desc, default: :asc)
    * `:completed_filter` - Filter by completion status ("true", "false", or nil for all)

  ## Examples

      iex> list_brands()
      [%Brand{}, ...]

      iex> list_brands(sort_by: :name, sort_direction: :desc)
      [%Brand{}, ...]

      iex> list_brands(completed_filter: "true")
      [%Brand{}, ...]

  """
  def list_brands(opts \\ []) do
    sort_by = Keyword.get(opts, :sort_by, :name)
    sort_direction = Keyword.get(opts, :sort_direction, :asc)
    completed_filter = Keyword.get(opts, :completed_filter)

    Brand
    |> maybe_filter_completed(completed_filter)
    |> order_by([b], [{^sort_direction, ^sort_by}])
    |> Repo.all()
  end

  defp maybe_filter_completed(query, nil), do: query
  defp maybe_filter_completed(query, completed) when is_binary(completed) do
    completed = completed == "true"
    from b in query, where: b.completed == ^completed
  end

  @doc """
  Gets a single brand.

  Raises `Ecto.NoResultsError` if the Brand does not exist.

  ## Examples

      iex> get_brand!(123)
      %Brand{}

      iex> get_brand!(456)
      ** (Ecto.NoResultsError)

  """
  def get_brand!(id), do: Repo.get!(Brand, id)

  @doc """
  Creates a brand.

  ## Examples

      iex> create_brand(%{field: value})
      {:ok, %Brand{}}

      iex> create_brand(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_brand(attrs) do
    %Brand{}
    |> Brand.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a brand.

  ## Examples

      iex> update_brand(brand, %{field: new_value})
      {:ok, %Brand{}}

      iex> update_brand(brand, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_brand(%Brand{} = brand, attrs) do
    brand
    |> Brand.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a brand.

  ## Examples

      iex> delete_brand(brand)
      {:ok, %Brand{}}

      iex> delete_brand(brand)
      {:error, %Ecto.Changeset{}}

  """
  def delete_brand(%Brand{} = brand) do
    Repo.delete(brand)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking brand changes.

  ## Examples

      iex> change_brand(brand)
      %Ecto.Changeset{data: %Brand{}}

  """
  def change_brand(%Brand{} = brand, attrs \\ %{}) do
    Brand.changeset(brand, attrs)
  end

  alias Precider.Catalog.Ingredient

  @doc """
  Returns the list of ingredients.

  ## Examples

      iex> list_ingredients()
      [%Ingredient{}, ...]

  """
  def list_ingredients do
    Ingredient
    |> order_by([i], asc: i.name)
    |> Repo.all()
  end

  @doc """
  Gets a single ingredient.

  Raises `Ecto.NoResultsError` if the Ingredient does not exist.

  ## Examples

      iex> get_ingredient!(123)
      %Ingredient{}

      iex> get_ingredient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  @doc """
  Creates a ingredient.

  ## Examples

      iex> create_ingredient(%{field: value})
      {:ok, %Ingredient{}}

      iex> create_ingredient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ingredient(attrs) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ingredient.

  ## Examples

      iex> update_ingredient(ingredient, %{field: new_value})
      {:ok, %Ingredient{}}

      iex> update_ingredient(ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ingredient.

  ## Examples

      iex> delete_ingredient(ingredient)
      {:ok, %Ingredient{}}

      iex> delete_ingredient(ingredient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.transaction(fn ->
      # First delete all associated product_ingredients
      Repo.delete_all(from pi in ProductIngredient, where: pi.ingredient_id == ^ingredient.id)
      # Then delete the ingredient
      Repo.delete(ingredient)
    end)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredient changes.

  ## Examples

      iex> change_ingredient(ingredient)
      %Ecto.Changeset{data: %Ingredient{}}

  """
  def change_ingredient(%Ingredient{} = ingredient, attrs \\ %{}) do
    Ingredient.changeset(ingredient, attrs)
  end

  alias Precider.Catalog.Product

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
    |> Repo.preload([:brand, :product_ingredients, :ingredients])
  end

  @doc """
  Returns a filtered list of products based on ingredient dosages.
  The dosage comparisons are unit-aware, converting all values to milligrams for comparison.

  ## Parameters

    * `filters` - A map containing filter criteria:
      * `:name` - Filter by product name
      * `:ingredient_mode` - Map of ingredient_id to mode ("include" or "exclude")
      * `:dosage_min` - Map of ingredient_id to minimum dosage
      * `:dosage_max` - Map of ingredient_id to maximum dosage
      * `:dosage_unit` - Map of ingredient_id to unit (:mg, :g, or :mcg)

  ## Examples

      iex> filter_products(%{name: "Protein", ingredient_mode: %{1 => "include"}, dosage_min: %{1 => "20"}, dosage_unit: %{1 => "g"}})
      [%Product{}, ...]

  """
  def filter_products(filters) do
    Product
    |> filter_by_name(filters[:name])
    |> filter_by_ingredients(filters)
    |> Repo.all()
    |> Repo.preload([:brand, :product_ingredients, :ingredients])
  end

  defp filter_by_name(query, nil), do: query
  defp filter_by_name(query, ""), do: query
  defp filter_by_name(query, name) do
    from p in query,
      where: ilike(p.name, ^"%#{name}%")
  end

  defp filter_by_ingredients(query, filters) do
    Enum.reduce(filters[:ingredient_mode] || %{}, query, fn {ingredient_id, mode}, query ->
      case mode do
        "include" ->
          min_dosage = filters[:dosage_min][ingredient_id]
          max_dosage = filters[:dosage_max][ingredient_id]
          unit = filters[:dosage_unit][ingredient_id]

          from p in query,
            join: pi in assoc(p, :product_ingredients),
            where: pi.ingredient_id == ^ingredient_id,
            where: ^build_dosage_where_clause(min_dosage, max_dosage, unit)

        "exclude" ->
          from p in query,
            left_join: pi in assoc(p, :product_ingredients),
            on: pi.ingredient_id == ^ingredient_id,
            where: is_nil(pi.id)

        _ -> query
      end
    end)
  end

  defp build_dosage_where_clause(min, max, unit) when not is_nil(unit) do
    conditions = []

    conditions = if min && min != "" do
      min_mg = convert_to_mg(Decimal.new(min), String.to_atom(unit))
      [dynamic([p, pi], 
        (pi.dosage_unit == :mg and fragment("? >= ?", pi.dosage_amount, ^min_mg)) or
        (pi.dosage_unit == :g and fragment("? * 1000.0 >= ?", pi.dosage_amount, ^min_mg)) or
        (pi.dosage_unit == :mcg and fragment("? / 1000.0 >= ?", pi.dosage_amount, ^min_mg))
      ) | conditions]
    else
      conditions
    end

    conditions = if max && max != "" do
      max_mg = convert_to_mg(Decimal.new(max), String.to_atom(unit))
      [dynamic([p, pi], 
        (pi.dosage_unit == :mg and fragment("? <= ?", pi.dosage_amount, ^max_mg)) or
        (pi.dosage_unit == :g and fragment("? * 1000.0 >= ?", pi.dosage_amount, ^max_mg)) or
        (pi.dosage_unit == :mcg and fragment("? / 1000.0 <= ?", pi.dosage_amount, ^max_mg))
      ) | conditions]
    else
      conditions
    end

    IO.inspect(conditions, label: "conditions")

    Enum.reduce(conditions, true, &dynamic([p, pi], ^&1 and ^&2))
  end
  defp build_dosage_where_clause(_min, _max, _unit), do: true

  defp convert_to_mg(amount, unit) do
    case unit do
      :mg -> amount
      :g -> Decimal.mult(amount, Decimal.new("1000"))
      :mcg -> Decimal.div(amount, Decimal.new("1000"))
      _ -> amount
    end
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id) do
    Repo.get!(Product, id)
    |> Repo.preload([:brand, :product_ingredients, :ingredients])
  end

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs) do
    # Transform the ingredient data into the format expected by cast_assoc
    attrs = if Map.has_key?(attrs, "ingredients") do
      product_ingredients = attrs
        |> Map.get("ingredients", %{})
        |> Map.values()
        |> Enum.map(fn ingredient ->
          %{
            "ingredient_id" => ingredient["ingredient_id"],
            "dosage_amount" => case ingredient["dosage"] do
              "" -> nil
              nil -> nil
              value -> Decimal.new(to_string(value))
            end,
            "dosage_unit" => String.to_atom(ingredient["unit"] || "mg")
          }
        end)

      Map.put(attrs, "product_ingredients", product_ingredients)
    else
      attrs
    end

    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    # Transform the ingredient data into the format expected by cast_assoc
    attrs = if Map.has_key?(attrs, "ingredients") do
      product_ingredients = attrs
        |> Map.get("ingredients", %{})
        |> Map.values()
        |> Enum.map(fn ingredient ->
          %{
            "ingredient_id" => ingredient["ingredient_id"],
            "dosage_amount" => case ingredient["dosage"] do
              "" -> nil
              nil -> nil
              value -> Decimal.new(to_string(value))
            end,
            "dosage_unit" => String.to_atom(ingredient["unit"] || "mg")
          }
        end)

      Map.put(attrs, "product_ingredients", product_ingredients)
    else
      attrs
    end

    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  alias Precider.Catalog.ProductIngredient

  @doc """
  Returns the list of product_ingredients.

  ## Examples

      iex> list_product_ingredients()
      [%ProductIngredient{}, ...]

  """
  def list_product_ingredients do
    Repo.all(ProductIngredient)
  end

  @doc """
  Gets a single product_ingredient.

  Raises `Ecto.NoResultsError` if the Product ingredient does not exist.

  ## Examples

      iex> get_product_ingredient!(123)
      %ProductIngredient{}

      iex> get_product_ingredient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_ingredient!(id), do: Repo.get!(ProductIngredient, id)

  @doc """
  Creates a product_ingredient.

  ## Examples

      iex> create_product_ingredient(%{field: value})
      {:ok, %ProductIngredient{}}

      iex> create_product_ingredient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_ingredient(attrs) do
    %ProductIngredient{}
    |> ProductIngredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_ingredient.

  ## Examples

      iex> update_product_ingredient(product_ingredient, %{field: new_value})
      {:ok, %ProductIngredient{}}

      iex> update_product_ingredient(product_ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_ingredient(%ProductIngredient{} = product_ingredient, attrs) do
    product_ingredient
    |> ProductIngredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_ingredient.

  ## Examples

      iex> delete_product_ingredient(product_ingredient)
      {:ok, %ProductIngredient{}}

      iex> delete_product_ingredient(product_ingredient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_ingredient(%ProductIngredient{} = product_ingredient) do
    Repo.delete(product_ingredient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_ingredient changes.

  ## Examples

      iex> change_product_ingredient(product_ingredient)
      %Ecto.Changeset{data: %ProductIngredient{}}

  """
  def change_product_ingredient(%ProductIngredient{} = product_ingredient, attrs \\ %{}) do
    ProductIngredient.changeset(product_ingredient, attrs)
  end

  def get_product_ingredients(%Product{} = product) do
    from(pi in ProductIngredient,
      where: pi.product_id == ^product.id,
      preload: [:ingredient]
    )
    |> Repo.all()
  end

  def get_brand_by_name(name) do
    Repo.get_by(Brand, name: name)
  end
end
