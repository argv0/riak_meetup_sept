% -*- mode: erlang -*-
{application, 
 rabbit_publisher,
 [{description,  "rabbit_publisher"},
  {id,           "rabbit_publisher"},
  {vsn,          "0.1"},
  {modules,      ['rabbit_publisher', 
                  'rabbit_publisher_app', 
                  'rabbit_publisher_server',
                  'rabbit_publisher_sup'
                 ]},
  {applications, [kernel, 
                  stdlib, 
                  sasl, 
                  crypto,
                  riak_core,
                  riak_kv]},
  {registered,   [rabbit_publisher_sup]},
  {mod,          {rabbit_publisher_app, []}},
  {env,          [
                  {rabbit_ip, "127.0.0.1"},
                  {rabbit_user, "guest"},
                  {rabbit_pass, "guest"},
                  {rabbit_queue, <<"riak.publish">>}
                 ]}
]}.
