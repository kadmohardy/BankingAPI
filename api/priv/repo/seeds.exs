# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StoneChallenge.Repo.insert!(%StoneChallenge.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias StoneChallenge.Banking
​ 
Banking.create_transaction_type!("Saque")
Banking.create_transaction_type!("Transferência")
