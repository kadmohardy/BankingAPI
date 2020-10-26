defmodule StoneChallengeWeb.UserViewTest do
  use StoneChallengeWeb.ConnCase, async: true
  import Phoenix.View
  require Logger

  test "renders index.json", %{conn: conn} do
    users = [
      %StoneChallenge.Accounts.User{
        id: "dc198650-4a44-41e6-ad92-e7b42ab9dead",
        email: "user1@gmail.com",
        first_name: "User1",
        last_name: "Test1",
        role: "customer",
        accounts: %StoneChallenge.Accounts.Account{
          id: "5cd95c73-f522-4bd9-935c-70643052cd88",
          balance: 1000.00
        }
      },
      %StoneChallenge.Accounts.User{
        id: "35b27696-e329-426b-a47e-03c42c1ef7a8",
        email: "user2@gmail.com",
        first_name: "User2",
        last_name: "Test2",
        role: "customer",
        accounts: %StoneChallenge.Accounts.Account{
          id: "4d41121d-fb2f-4895-abe4-818d2d8a4bf6",
          balance: 1000.00
        }
      }
    ]

    rendered_users =
      render(
        StoneChallengeWeb.UserView,
        "index.json",
        conn: conn,
        users: users
      )

    assert rendered_users == %{
             data:
               Enum.map(users, fn item -> StoneChallengeWeb.UserView.user_account_json(item) end)
           }
  end

  test "renders account.json", %{conn: conn} do
    {user, account} = {
      %StoneChallenge.Accounts.User{
        id: "dc198650-4a44-41e6-ad92-e7b42ab9dead",
        email: "user1@gmail.com",
        first_name: "User1",
        last_name: "Test1",
        role: "customer"
      },
      %StoneChallenge.Accounts.Account{
        id: "5cd95c73-f522-4bd9-935c-70643052cd88",
        balance: 1000.00
      }
    }

    rendered_account =
      render(
        StoneChallengeWeb.UserView,
        "account.json",
        conn: conn,
        account: account,
        user: user
      )

    assert rendered_account == %{
             account_id: account.id,
             balance: account.balance,
             user: %{
               id: user.id,
               email: user.email,
               first_name: user.first_name,
               last_name: user.last_name,
               role: user.role
             }
           }
  end
end
