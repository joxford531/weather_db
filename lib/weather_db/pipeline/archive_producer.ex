defmodule WeatherDb.Pipeline.ArchiveProducer do
  use GenStage

  def start_link(_args) do
    GenStage.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    {:producer, {:queue.new(), 0}}
  end

  def archive_date(date) do
    GenServer.call(__MODULE__, {:enqueue, date})
  end

   # this callback is used whenever consumers register demand, we know the constume will be at most at demand of 1
  def handle_demand(_incoming, {queue, demand}) do
    with {item, queue} <- :queue.out(queue),
        {:value, event} <- item do
      {:noreply, [event], {queue, demand}}
    else
      _ -> {:noreply, [], {queue, demand + 1}}
    end
  end

  def handle_call({:enqueue, event}, from, {queue, 0}) do
    queue = :queue.in(event, queue)
    GenStage.reply(from, :ok)

    {:noreply, [], {queue, 0}}
  end

  def handle_call({:enqueue, event}, from, {queue, demand}) do
    queue = :queue.in(event, queue)
    GenStage.reply(from, :ok)

    {{:value, event}, queue} = :queue.out(queue)
    {:noreply, [event], {queue, demand - 1}}
  end
end
