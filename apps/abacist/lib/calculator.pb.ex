defmodule Abacus.ArithmeticRequest do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field(:a, 1, type: :int32)
  field(:b, 2, type: :int32)
  field(:type, 3, type: :string)
end

defmodule Abacus.ArithmeticReply do
  @moduledoc false

  use Protobuf, syntax: :proto3, protoc_gen_elixir_version: "0.12.0"

  field(:result, 1, type: :int32)
end

defmodule Abacus.Calculator.Service do
  @moduledoc false

  use GRPC.Service, name: "abacus.Calculator", protoc_gen_elixir_version: "0.12.0"

  rpc(:Calculate, Abacus.ArithmeticRequest, Abacus.ArithmeticReply)
end

defmodule Abacus.Calculator.Stub do
  @moduledoc false

  use GRPC.Stub, service: Abacus.Calculator.Service
end
