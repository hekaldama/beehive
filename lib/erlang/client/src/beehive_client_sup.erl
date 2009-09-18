-module (beehive_client_sup).
-include ("beehive_app.hrl").
-export([start_link/1, init/1]).

start_link(Args) ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, Args).

init(Args) ->
    {ok, {{one_for_one, ?MAXIMUM_RESTARTS, ?MAX_DELAY_TIME}, [
        {beehive_client, {beehive_client, start_link, [Args]}, permanent, 2000, worker, [beehive_client]}
    ]}}.