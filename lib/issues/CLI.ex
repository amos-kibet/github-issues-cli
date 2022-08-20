defmodule Issues.CLI do
  import Issues.TableFormatter, only: [print_table_for_columns: 2]
  @default_count 4

  @moduledoc """
  Handle the command line parsing and then dispatch to
  the various functions that end up generating a
  table of the last_n_issues in a github project
  """

  def main(argv) do
    argv
    |> parse_args()
    |> process
  end

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [count | #{@default_count}]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_response()
    |> sort_into_descending_order()
    |> last(count)
    |> print_table_for_columns(["number", "created_at", "title"])
  end

  def last(list, count) do
    list
    |> Enum.take(count)
    |> Enum.reverse()
  end

  def sort_into_descending_order(list_of_issues) do
    list_of_issues
    |> Enum.sort(fn i1, i2 ->
      i1["created_at"] >= i2["created_at"]
    end)
  end

  def decode_response({:ok, body}), do: body

  def decode_response({:error, error}) do
    IO.puts("Error fetching from GitHub: #{error["message"]}")
    System.halt(2)
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.

  Return a tuple of `{user, project, count}` or `:help` if help was given.
  """
  # def parse_args(argv) do
  #   parse = OptionParser.parse(
  #     argv, switches: [help: :boolean], aliases: [h: :help])

  #   case parse do
  #     {[help: true], _, _} -> :help
  #     {_, [user, project, count], _} -> {user, project, String.to_integer(count)}
  #     {_, [user, project], _} -> {user, project, @default_count}
  #     _ -> :help
  #   end
  # end

  # refactored parse_args/1 function
  def parse_args(argv) do
    # parses argv into a Keyword List
    OptionParser.parse(argv, switches: [help: :boolean], aliases: [h: :help])
    # gets element at index 1 (not sure though)
    |> elem(1)
    |> args_to_internal_representation()
  end

  def args_to_internal_representation([user, project, count]) do
    {user, project, String.to_integer(count)}
  end

  def args_to_internal_representation([user, project]) do
    {user, project, @default_count}
  end

  # bad arg or --help
  def args_to_internal_representation(_) do
    :help
  end
end
