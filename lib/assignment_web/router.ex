defmodule AssignmentWeb.Router do
  use AssignmentWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through(:api)

    forward "/api", Absinthe.Plug, schema: AssignmentWeb.GraphQL.Schema

    forward("/graphiql", Absinthe.Plug.GraphiQL,
      schema: AssignmentWeb.GraphQL.Schema,
      interface: :simple
    )
  end
end
