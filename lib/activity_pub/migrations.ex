defmodule ActivityPub.Migrations do
  use Ecto.Migration
  import Pointers.Migration

  def up do
    create table("ap_object", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :data, :map
      add :local, :boolean
      add :public, :boolean
      add :pointer_id, weak_pointer()

      timestamps(type: :utc_datetime_usec)
    end

    create unique_index(:ap_object, ["(data->>'id')"])
    create unique_index(:ap_object, [:pointer_id])

    create table("ap_instance", primary_key: false) do
      add :id, :uuid, primary_key: true
      add :host, :string
      add :unreachable_since, :naive_datetime_usec

      timestamps()
    end

    create unique_index("ap_instance", [:host])
    create index("ap_instance", [:unreachable_since])
  end

  def down do
    drop table("ap_object")
    drop index(:ap_object, ["(data->>'id')"])
    drop index(:ap_object, [:pointer_id])
    drop table("ap_instance")
    drop index("ap_instance", [:host])
    drop index("ap_instance", [:unreachable_since])
  end

  def upgrade do
    rename table("ap_object"), :mn_pointer_id, to: :pointer_id
  end
end
