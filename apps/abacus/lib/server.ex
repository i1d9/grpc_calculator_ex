defmodule Abacus.Server do
  use GRPC.Server, service: Abacus.Calculator.Service

  def calculate(
        %Abacus.ArithmeticRequest{
          a: a,
          b: b,
          type: "addition"
        },
        _stream
      ),
      do: %Abacus.ArithmeticReply{
        result: a + b
      }

  def calculate(
        %Abacus.ArithmeticRequest{
          a: a,
          b: b,
          type: "multiplication"
        },
        _stream
      ),
      do: %Abacus.ArithmeticReply{
        result: a * b
      }

  def calculate(
        %Abacus.ArithmeticRequest{
          a: a,
          b: b,
          type: "division"
        },
        _stream
      ),
      do: %Abacus.ArithmeticReply{
        result: div(b, a)
      }

  def calculate(
        %Abacus.ArithmeticRequest{
          a: _,
          b: _,
          type: _
        },
        _stream
      ),
      do: %Abacus.ArithmeticReply{
        result: 0
      }
end
