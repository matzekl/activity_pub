defmodule ActivityPub.TestRepo.Migrations.CreatePointersTable do
  use Ecto.Migration

  def up(), do: inits(:up)
  def down(), do: inits(:down)

  defp inits(dir) do
    if Code.ensure_loaded?(Pointers.Migration) do
      # init_pointers_ulid_extra(dir) # this one is optional but recommended
      # this one is not optional
      Pointers.Migration.init_pointers(dir)
    end
  end
end
