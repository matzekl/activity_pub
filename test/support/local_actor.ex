defmodule ActivityPub.LocalActor do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  import ActivityPub.Common

  @type t :: %__MODULE__{}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "local_actor" do
    field(:data, :map)
    field(:local, :boolean)
    field(:username, :string)
    field(:keys, :string)
    field(:followers, {:array, :string}, default: [])
  end

  def get(id: id), do: repo().get(__MODULE__, id)

  def get(ap_id: ap_id) do
    repo().one(
      from(actor in __MODULE__,
        where: fragment("(?)->>'id' = ?", actor.data, ^ap_id)
      )
    )
  end

  def get_cached(username: username) do
    repo().get_by(__MODULE__, username: username)
  end

  def insert(attrs) do
    attrs
    |> changeset()
    |> repo().insert()
  end

  def changeset(attrs) do
    %__MODULE__{}
    |> changeset(attrs)
  end

  def changeset(object, attrs) do
    object
    |> cast(attrs, [:data, :local, :username, :keys])
    |> validate_required([:data, :username])
  end

  def update(object, attrs) do
    object
    |> change(attrs)
    |> repo().update()
  end

  def follow(follower, followee) do
    followee = get(ap_id: followee.data["id"])
    followers = [follower.id | followee.followers]
    __MODULE__.update(followee, %{followers: followers})
  end
end
