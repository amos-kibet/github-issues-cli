defmodule CLITest do
  use ExUnit.Case
  doctest Issues

  # import modules & functions you want to test
  import Issues.CLI, only: [sort_into_descending_order: 1]

  test "sort descending orders the correct way" do
    result = sort_into_descending_order(fake_created_at_list(["c", "a", "b"]))
    issues = for issue <- result, do: Map.get(issue, "created_at")
    assert issues == ~w{ c b a }
  end

  defp fake_created_at_list(values) do
    for value <- values,
        do: %{"created_at" => value, "other_data" => "xxx"}
  end
end
