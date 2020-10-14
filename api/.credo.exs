%{
  configs: [
    %{
      name: "defail",
      files: %{
        included: ~w{config lib test}
      },
      strict: true,
      color: true,
      checks: [
        {Credo.Check.Readability.MaxLineLength, max_length: 100}
      ]
    }
  ]
}
