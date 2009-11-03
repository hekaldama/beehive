%%%-------------------------------------------------------------------
%%% File    : app_srv_sup.erl
%%% Author  : Ari Lerner
%%% Description : 
%%%
%%% Created :  Thu Oct  8 02:09:02 PDT 2009
%%%-------------------------------------------------------------------

-module (app_srv_sup).
-include ("router.hrl").
-behaviour(supervisor).

%% API
-export ([start_client/1]).
-export([start_link/1]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================
%%--------------------------------------------------------------------
%% Function: start_link() -> {ok,Pid} | ignore | {error,Error}
%% Description: Starts the supervisor
%%--------------------------------------------------------------------
start_client(Mod) -> supervisor:start_child(the_kv_store, [Mod]).
start_link(Module) -> supervisor:start_link({local, ?SERVER}, ?MODULE, [Module]).

%%====================================================================
%% Supervisor callbacks
%%====================================================================
%%--------------------------------------------------------------------
%% Func: init(Args) -> {ok,  {SupFlags,  [ChildSpec]}} |
%%                     ignore                          |
%%                     {error, Reason}
%% Description: Whenever a supervisor is started using
%% supervisor:start_link/[2,3], this function is called by the new process
%% to find out about restart strategy, maximum restart frequency and child
%% specifications.
%%--------------------------------------------------------------------
init([Module]) ->
  AppSrv  = {the_app_srv,{app_srv, start_link,[]}, permanent,2000,worker,dynamic},
  KVStore = {the_kv_store,{supervisor,start_link,[{local, the_kv_store}, ?MODULE, [start_module, Module]]},permanent,infinity,supervisor,[]},
  AppManagerSrv  = {the_app_manager,{app_manager, start_link,[]}, permanent, 2000, worker, dynamic},
  
  {ok,{{one_for_one,5,10}, [
      KVStore,
      AppSrv,
      AppManagerSrv
    ]}};
  
init([start_module, Module]) ->
  ModSrv = {undefined,{Module,start_link,[]},temporary,2000,worker,[]},
  {ok, {{simple_one_for_one, 5, 10}, [ModSrv]}}.

%%====================================================================
%% Internal functions
%%====================================================================