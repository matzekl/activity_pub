defmodule ActivityPub.SignatureTest do
  use ActivityPub.DataCase

  import ActivityPub.Factory
  import ExUnit.CaptureLog
  import Tesla.Mock

  alias ActivityPub.Signature

  setup do
    mock(fn env -> apply(ActivityPub.Test.HttpRequestMock, :request, [env]) end)
    :ok
  end

  defp make_fake_signature(key_id), do: "keyId=\"#{key_id}\""

  defp make_fake_conn(key_id),
    do: %Plug.Conn{
      req_headers: %{"signature" => make_fake_signature(key_id <> "#main-key")}
    }

  describe "fetch_public_key/1" do
    test "works" do
      id = "https://mocked.local/users/karen"

      {:ok, {:RSAPublicKey, _, _}} = Signature.fetch_public_key(make_fake_conn(id))
    end

    test "it returns {:ok, :nil} when not found user" do
      assert capture_log(fn ->
               assert Signature.fetch_public_key(make_fake_conn("test-ap_id")) ==
                        {:ok, nil}
             end)
    end
  end

  describe "refetch_public_key/2" do
    test "works" do
      id = "https://mocked.local/users/karen"

      {:ok, {:RSAPublicKey, _, _}} = Signature.refetch_public_key(make_fake_conn(id))
    end

    test "it returns error when not found user" do
      assert capture_log(fn ->
               assert {:error, {:error, _}} = Signature.refetch_public_key(make_fake_conn("test-id")) 
                        
             end)
    end
  end

  describe "sign/2" do
    test "works" do
      actor = local_actor()
      {:ok, ap_actor} = ActivityPub.Actor.get_cached(username: actor.username)

      _signature =
        Signature.sign(ap_actor, %{
          host: "test.test",
          "content-length": 100
        })
    end
  end
end
