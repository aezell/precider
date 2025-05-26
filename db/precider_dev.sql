--
-- PostgreSQL database dump
--

-- Dumped from database version 15.8
-- Dumped by pg_dump version 15.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA supabase_migrations;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: dosage_unit_enum; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.dosage_unit_enum AS ENUM (
    'mg',
    'g',
    'mcg'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brands (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    logo_url character varying(255),
    website character varying(255),
    description text,
    slug character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    completed boolean DEFAULT false NOT NULL
);


--
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brands_id_seq OWNED BY public.brands.id;


--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ingredients (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    benefits text,
    slug character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ingredients_id_seq OWNED BY public.ingredients.id;


--
-- Name: product_ingredients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.product_ingredients (
    id bigint NOT NULL,
    dosage_unit public.dosage_unit_enum NOT NULL,
    product_id bigint NOT NULL,
    ingredient_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    dosage_amount numeric(10,2)
);


--
-- Name: product_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_ingredients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_ingredients_id_seq OWNED BY public.product_ingredients.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.products (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    url character varying(255),
    image_url character varying(255),
    price numeric(10,2) NOT NULL,
    serving_size character varying(255),
    servings_per_container integer,
    weight_in_grams integer,
    is_active boolean DEFAULT true NOT NULL,
    slug character varying(255),
    search_vector tsvector,
    brand_id bigint NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.products.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email public.citext NOT NULL,
    hashed_password character varying(255),
    confirmed_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: users_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_tokens (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    token bytea NOT NULL,
    context character varying(255) NOT NULL,
    sent_to character varying(255),
    authenticated_at timestamp(0) without time zone,
    inserted_at timestamp(0) without time zone NOT NULL
);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_tokens_id_seq OWNED BY public.users_tokens.id;


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


--
-- Name: seed_files; Type: TABLE; Schema: supabase_migrations; Owner: -
--

CREATE TABLE supabase_migrations.seed_files (
    path text NOT NULL,
    hash text NOT NULL
);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: brands id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands ALTER COLUMN id SET DEFAULT nextval('public.brands_id_seq'::regclass);


--
-- Name: ingredients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredients ALTER COLUMN id SET DEFAULT nextval('public.ingredients_id_seq'::regclass);


--
-- Name: product_ingredients id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_ingredients ALTER COLUMN id SET DEFAULT nextval('public.product_ingredients_id_seq'::regclass);


--
-- Name: products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_tokens id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens ALTER COLUMN id SET DEFAULT nextval('public.users_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at) FROM stdin;
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag) FROM stdin;
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
\.


--
-- Data for Name: brands; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.brands (id, name, logo_url, website, description, slug, inserted_at, updated_at, completed) FROM stdin;
2	Centurion Labz	\N	https://centurionlabz.com/	\N	centurion-labz	2025-05-08 21:37:00	2025-05-08 21:37:00	f
3	Nutrex Research	\N	https://nutrex.com/	\N	nutrex-research	2025-05-08 21:45:52	2025-05-08 21:45:52	f
5	Gorilla Mind	\N	https://gorillamind.com/	\N	gorilla-mind	2025-05-08 21:47:02	2025-05-08 21:47:02	f
6	Frontline Formulations	\N	https://frontlineformulations.com/	\N	frontline-formulations	2025-05-08 21:47:24	2025-05-08 21:47:24	f
9	SAN Nutrition	\N	https://www.sann.net/	\N	san-nutrition	2025-05-08 21:48:37	2025-05-08 21:48:37	f
10	Axe & Sledge	\N	https://axeandsledge.com/	\N	axe-sledge	2025-05-08 21:49:11	2025-05-08 21:49:11	f
12	Inno Supps	\N	https://www.innosupps.com/	\N	inno-supps	2025-05-08 21:50:30	2025-05-08 21:50:30	f
13	Panda Supps	\N	https://www.pandasupps.com/	\N	panda-supps	2025-05-08 21:50:45	2025-05-08 21:50:45	f
14	Avry Labs	\N	https://www.avrylabs.com/	\N	avry-labs	2025-05-08 21:51:07	2025-05-08 21:51:07	f
15	Black Magic Supply	\N	https://www.blackmagicsupps.com/	\N	black-magic-supply	2025-05-08 21:51:25	2025-05-08 21:51:25	f
16	Bucked Up	\N	https://www.buckedup.com/	\N	bucked-up	2025-05-08 21:51:40	2025-05-08 21:51:40	f
17	Blk Flg	\N	https://blkflg.com/	\N	blk-flg	2025-05-08 21:52:02	2025-05-08 21:52:02	f
18	Formulation Factory	\N	https://formulationfactory.com/	\N	formulation-factory	2025-05-08 21:52:26	2025-05-08 21:52:26	f
19	Klerpath Nutrition	\N	https://klerpath.com/	\N	klerpath-nutrition	2025-05-08 21:53:18	2025-05-08 21:53:18	f
20	Nutristat	\N	https://nutristat.com/	\N	nutristat	2025-05-08 21:53:54	2025-05-08 21:53:54	f
21	Bullfit	\N	https://bullfit.com/	\N	bullfit	2025-05-08 21:54:11	2025-05-08 21:54:11	f
22	Revolution Nutrition	\N	https://revolution-nutrition.com/	\N	revolution-nutrition	2025-05-08 21:54:31	2025-05-08 21:54:31	f
24	Ryse Supplements	\N	https://rysesupps.com/	\N	ryse-supplements	2025-05-08 21:55:09	2025-05-08 21:55:09	f
25	Transparent Labs	\N	https://www.transparentlabs.com/	\N	transparent-labs	2025-05-08 21:56:52	2025-05-08 21:56:52	f
26	Steel Supplements	\N	https://steelsupplements.com/	\N	steel-supplements	2025-05-08 21:57:15	2025-05-08 21:57:15	f
27	White Lion Labs	\N	https://whitelionlabs.com/	\N	white-lion-labs	2025-05-08 21:57:33	2025-05-08 21:57:33	f
28	Gaspari Nutrition	\N	https://gasparinutrition.com/	\N	gaspari-nutrition	2025-05-08 21:57:50	2025-05-08 21:57:50	f
29	Wave Supplement	\N	https://www.wavesupplement.co/	\N	wave-supplement	2025-05-08 21:58:19	2025-05-08 21:58:19	f
30	Global Formulas	\N	https://globalformulas.com/	\N	global-formulas	2025-05-08 21:58:38	2025-05-08 21:58:38	f
31	Black Market Labs	\N	https://blackmarketlabs.com/	\N	black-market-labs	2025-05-08 21:58:55	2025-05-08 21:58:55	f
32	GAT Sport	\N	https://gatsport.com/	\N	gat-sport	2025-05-08 21:59:09	2025-05-08 21:59:09	f
33	Enhanced Labs	\N	https://enhancedlabs.com/	\N	enhanced-labs	2025-05-08 21:59:27	2025-05-08 21:59:27	f
34	NutraBio	\N	https://nutrabio.com/	\N	nutrabio	2025-05-08 21:59:43	2025-05-08 21:59:43	f
35	Kaged	\N	https://www.kaged.com/	\N	kaged	2025-05-08 22:00:06	2025-05-08 22:00:06	f
36	Redsalt	\N	https://redsaltsupps.com/	\N	redsalt	2025-05-08 22:00:20	2025-05-08 22:00:20	f
37	Titan Nutrition	\N	https://titannutrition.net/	\N	titan-nutrition	2025-05-08 22:00:37	2025-05-08 22:00:37	f
38	Iron Outlaws	\N	https://ironoutlaws.com/	\N	iron-outlaws	2025-05-08 22:01:17	2025-05-08 22:01:17	f
39	Core Nutritionals	\N	https://www.corenutritionals.com/	\N	core-nutritionals	2025-05-08 22:01:44	2025-05-08 22:01:44	f
40	Shifted	\N	https://getshifted.com/	\N	shifted	2025-05-08 22:02:19	2025-05-08 22:02:19	f
41	EFX Sports	\N	https://efxsports.com/	\N	efx-sports	2025-05-08 22:02:38	2025-05-08 22:02:38	f
42	Metabolic Nutrition	\N	https://metabolicnutrition.com/	\N	metabolic-nutrition	2025-05-08 22:03:02	2025-05-08 22:03:02	f
43	MuscleSport	\N	https://musclesport.com/	\N	musclesport	2025-05-08 22:03:24	2025-05-08 22:03:24	f
44	Huge Supplements	\N	https://hugesupplements.com/	\N	huge-supplements	2025-05-08 22:03:39	2025-05-08 22:03:39	f
45	Complete Nutrition	\N	https://completenutrition.com/	\N	complete-nutrition	2025-05-08 22:04:03	2025-05-08 22:04:03	f
46	Psycho Pharma	\N	https://www.psychopharma.com/	\N	psycho-pharma	2025-05-08 22:04:25	2025-05-08 22:04:25	f
47	Ninja	\N	https://ninjaup.com/	\N	ninja	2025-05-08 22:04:43	2025-05-08 22:04:43	f
49	Swolverine	\N	https://swolverine.com/	\N	swolverine	2025-05-08 22:05:16	2025-05-08 22:05:16	f
50	NG Nutra	\N	https://ngnutra.com/	\N	ng-nutra	2025-05-08 22:05:31	2025-05-08 22:05:31	f
51	Millecor	\N	https://millecor.com/	\N	millecor	2025-05-08 22:05:45	2025-05-08 22:05:45	f
52	Ghost	\N	https://www.ghostlifestyle.com/	\N	ghost	2025-05-08 22:06:16	2025-05-08 22:06:16	f
53	Cellucor	\N	https://cellucor.com/	\N	cellucor	2025-05-08 22:06:46	2025-05-08 22:06:46	f
54	Legion Athletics	\N	https://legionathletics.com/	\N	legion-athletics	2025-05-08 22:07:06	2025-05-08 22:07:06	f
55	Build Fast Formula	\N	https://buildfastformula.com/	\N	build-fast-formula	2025-05-08 22:07:24	2025-05-08 22:07:24	f
71	1st Phorm	\N	https://1stphorm.com/	\N	1st-phorm	2025-05-08 22:35:37	2025-05-11 21:28:20	t
57	Onnit	\N	https://www.onnit.com/	\N	onnit	2025-05-08 22:08:31	2025-05-08 22:08:31	f
58	Type Zero Health	\N	https://typezerohealth.com/	\N	type-zero-health	2025-05-08 22:08:47	2025-05-08 22:08:47	f
59	Condemned Labz	\N	https://condemnedlabz.com/	\N	condemned-labz	2025-05-08 22:09:05	2025-05-08 22:09:05	f
60	Reach Supplements	\N	https://reachsupps.com/	\N	reach-supplements	2025-05-08 22:09:23	2025-05-08 22:09:23	f
61	Zim Fit	\N	https://zimfitusa.com/	\N	zim-fit	2025-05-08 22:09:37	2025-05-08 22:09:37	f
62	Bare Performance Nutrition	\N	https://www.bareperformancenutrition.com/	\N	bare-performance-nutrition	2025-05-08 22:10:04	2025-05-08 22:10:04	f
64	We Go Home	\N	https://wegohomesupps.com/	\N	we-go-home	2025-05-08 22:10:43	2025-05-08 22:10:43	f
65	JYM Supplements	\N	https://jymsupplementscience.com/	\N	jym-supplements	2025-05-08 22:11:01	2025-05-08 22:11:01	f
66	Redcon1	\N	https://redcon1.com/	\N	redcon1	2025-05-08 22:11:20	2025-05-08 22:11:20	f
67	Granite Nutrition	\N	https://granitenutrition.com/	\N	granite-nutrition	2025-05-08 22:11:39	2025-05-08 22:11:39	f
137	Frenetik Labs	\N	https://frenetiklabs.com/	\N	frenetik-labs	2025-05-14 15:48:20	2025-05-14 15:48:20	f
70	Magnum	\N	https://magnumsupps.com	\N	magnum	2025-05-08 22:13:43	2025-05-08 22:13:43	f
23	5% Nutrition	\N	https://5percentnutrition.com/	\N	5-nutrition	2025-05-08 21:54:50	2025-05-14 17:06:46	t
8	AI Nutrition	\N	https://ainutrition.com/	\N	ai-nutrition	2025-05-08 21:48:17	2025-05-14 22:11:40	t
63	Alpha Country	\N	https://thealphacountry.com/	\N	alpha-country	2025-05-08 22:10:24	2025-05-14 22:21:05	t
4	Alpha Lion	\N	https://www.alphalion.com/	\N	alpha-lion	2025-05-08 21:46:20	2025-05-18 00:26:44	t
11	Anabolic Warfare	\N	https://anabolicwarfare.defynedbrands.com/	\N	anabolic-warfare	2025-05-08 21:50:13	2025-05-18 02:29:19	t
1	Animal Pak	\N	https://www.animalpak.com/	Animal Pak Supplements	animal-pak	2025-04-30 22:52:44	2025-05-24 18:58:06	t
7	AN Performance	\N	https://ansupps.com/	\N	an-performance	2025-05-08 21:47:48	2025-05-24 19:47:56	t
48	Apollon Nutrition	\N	https://www.apollonnutrition.com/	\N	apollon-nutrition	2025-05-08 22:05:00	2025-05-24 20:17:05	t
\.


--
-- Data for Name: ingredients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ingredients (id, name, description, benefits, slug, inserted_at, updated_at) FROM stdin;
197	Creatine	A naturally occurring compound found in muscle cells that helps produce energy during high-intensity exercise and heavy lifting. Considered one of the most researched and effective supplements available.	Increases strength, power output, and muscle size; improves high-intensity exercise performance; supports ATP regeneration	creatine	2025-05-11 02:13:56	2025-05-11 02:13:56
198	L-Citrulline	An amino acid that converts to L-arginine in the body, leading to increased nitric oxide production and vasodilation. Often preferred over direct L-arginine supplementation due to better absorption.	Enhances nitric oxide production; improves blood flow and oxygen delivery; reduces muscle soreness; may increase exercise performance	l-citrulline	2025-05-11 02:13:56	2025-05-11 02:13:56
199	Beta Alanine	A non-essential amino acid that combines with histidine to form carnosine, which helps buffer acid in muscles. Known for causing harmless tingling sensation (paresthesia) when consumed.	Increases muscle carnosine levels; buffers lactic acid; improves exercise endurance; enhances performance in high-intensity activities lasting 1-4 minutes	beta-alanine	2025-05-11 02:13:56	2025-05-11 02:13:56
200	Betaine Anhydrous	A naturally occurring compound found in foods like beets, spinach, and whole grains. Works as an osmolyte to maintain cell hydration and as a methyl donor in many biological processes.	Enhances protein synthesis; may increase strength and power output; supports hydration at cellular level; potential fat loss effects	betaine-anhydrous	2025-05-11 02:13:56	2025-05-11 02:13:56
201	L-Taurine	A conditionally essential amino acid with antioxidant properties. Helps regulate water balance, mineral levels, and supports proper muscle function including heart muscle.	Supports cell hydration; reduces oxidative stress; improves endurance; enhances recovery; supports cardiovascular function	l-taurine	2025-05-11 02:13:56	2025-05-11 02:13:56
202	L-Tyrosine	An amino acid that serves as a precursor to dopamine, adrenaline, and noradrenaline. Particularly effective during high-stress situations or sleep deprivation.	Supports cognitive function during stress; maintains mental performance; helps produce neurotransmitters; may reduce stress symptoms	l-tyrosine	2025-05-11 02:13:56	2025-05-11 02:13:56
203	L-Arginine	An amino acid involved in nitric oxide production, though less effective than citrulline for this purpose due to poor absorption when taken orally. Has roles in wound healing and immune function.	Precursor to nitric oxide; may enhance blood flow; supports immune function; assists in protein synthesis	l-arginine	2025-05-11 02:13:57	2025-05-11 02:13:57
204	L-Theanine	An amino acid found primarily in tea leaves that crosses the blood-brain barrier. Creates a state of relaxed alertness and synergizes well with caffeine by reducing jitters and crash.	Promotes calm alertness; reduces stress without sedation; smooths out caffeine side effects; improves focus when paired with caffeine	l-theanine	2025-05-11 02:13:57	2025-05-11 02:13:57
205	Caffeine Anhydrous	A dehydrated form of caffeine that is more concentrated and faster-absorbing than regular caffeine. Works by blocking adenosine receptors in the brain and stimulating the central nervous system.	Increases alertness and energy; enhances focus and concentration; improves endurance performance; reduces perceived exertion; mobilizes fat for energy	caffeine-anhydrous	2025-05-11 02:13:57	2025-05-11 02:13:57
206	Choline Bitartrate	A form of choline, an essential nutrient that serves as a building block for acetylcholine, a neurotransmitter important for muscle control and cognitive function.	Supports cognitive function; enhances mind-muscle connection; precursor to acetylcholine; may improve exercise performance	choline-bitartrate	2025-05-11 02:13:57	2025-05-11 02:13:57
207	Theacrine	A naturally occurring compound with a structure similar to caffeine, found in Kucha tea. Provides energy and cognitive enhancement with reduced risk of habituation compared to caffeine.	Provides sustained energy without tolerance development; enhances mood and focus; similar to caffeine but with less crash	theacrine	2025-05-11 02:13:57	2025-05-11 02:13:57
208	Theobromine	A compound found in cocoa that is similar to caffeine but with milder, longer-lasting effects. Works as a vasodilator and may support cardiovascular health.	Mild stimulant effects; smoother energy than caffeine; supports vasodilation; potential mood enhancement	theobromine	2025-05-11 02:13:57	2025-05-11 02:13:57
209	Alpha GPC	A choline-containing compound that readily crosses the blood-brain barrier. Delivers choline to the brain more effectively than choline bitartrate, supporting cognitive function and strength performance.	Increases acetylcholine levels; enhances cognitive function; may improve power output; supports cellular membrane health	alpha-gpc	2025-05-11 02:13:57	2025-05-11 02:13:57
210	Huperzine A	A compound extracted from Chinese club moss that works as an acetylcholinesterase inhibitor, preventing the breakdown of acetylcholine and thereby increasing its levels in the brain.	Inhibits acetylcholine breakdown; enhances focus and mental clarity; may improve memory; increases muscle contraction efficiency	huperzine-a	2025-05-11 02:13:57	2025-05-11 02:13:57
211	AstraGin	A proprietary blend of astragalus and panax notoginseng that has been shown to improve absorption of various nutrients including amino acids, vitamins, and minerals.	Enhances nutrient absorption; improves uptake of amino acids; may increase ATP production; supports gut health	astragin	2025-05-11 02:13:57	2025-05-11 02:13:57
212	InnovaTea	\N	\N	innovatea	2025-05-11 02:13:57	2025-05-11 02:13:57
213	Agmatine Sulfate	A metabolite of L-arginine that helps regulate nitric oxide synthase enzymes, potentially increasing nitric oxide production and enhancing blood flow to working muscles.	Enhances nitric oxide production; supports pain management; may enhance muscle pumps; potential cognitive benefits	agmatine-sulfate	2025-05-11 02:13:57	2025-05-11 02:13:57
214	Yohimbine	An alkaloid derived from the bark of the yohimbe tree that blocks alpha-2 adrenergic receptors, potentially increasing fat burning, especially in "stubborn" fat areas. Can increase heart rate and anxiety in some individuals.	Promotes fat loss, especially from stubborn areas; increases adrenaline levels; may enhance physical performance	yohimbine	2025-05-11 02:13:57	2025-05-11 02:13:57
215	Citrafuze	\N	\N	citrafuze	2025-05-11 02:13:58	2025-05-11 02:13:58
216	Di-Caffeine Malate	\N	\N	di-caffeine-malate	2025-05-11 02:13:58	2025-05-11 02:13:58
217	D-Aspartic Acid	An amino acid that plays a role in hormone production, particularly testosterone. Often used by men looking to support natural testosterone levels.	May temporarily increase testosterone levels; supports hormone production; potential benefits for muscle growth and recovery	d-aspartic-acid	2025-05-11 02:13:58	2025-05-11 02:13:58
218	DMAE	Dimethylaminoethanol is a compound that may increase acetylcholine production in the brain, potentially enhancing cognitive function and focus during workouts.	Enhances cognitive function; may improve mood; supports skin health; precursor to acetylcholine	dmae	2025-05-11 02:13:58	2025-05-11 02:13:58
219	N-Phenethyl Dimethylamine Citrate	\N	\N	n-phenethyl-dimethylamine-citrate	2025-05-11 02:13:58	2025-05-11 02:13:58
220	L-Norvaline	\N	\N	l-norvaline	2025-05-11 02:13:58	2025-05-11 02:13:58
221	Beta Phenylethylamine HCL	\N	\N	beta-phenylethylamine-hcl	2025-05-11 02:13:58	2025-05-11 02:13:58
223	GBB (Gamma Butyrobetaine Ethyl Ester)	\N	\N	gbb-gamma-butyrobetaine-ethyl-ester	2025-05-11 02:13:58	2025-05-11 02:13:58
222	Mucuna Pruriens	A tropical legume containing L-DOPA, a precursor to dopamine. May support hormone levels, mood, and motivation for workouts. Also called velvet bean.	Natural source of L-DOPA; may support dopamine levels; potential testosterone support; mood enhancement	mucuna-pruriens	2025-05-11 02:13:58	2025-05-11 02:13:58
232	Acetyl-L-Carnitine	A more bioavailable form of L-carnitine that better crosses the blood-brain barrier. Helps transport fatty acids into mitochondria for energy production and offers neuroprotective benefits.	Supports fat metabolism; may enhance cognitive function; reduces mental fatigue; aids recovery from exercise	acetyl-l-carnitine	2025-05-11 02:13:59	2025-05-11 02:13:59
242	Ashwagandha	An adaptogenic herb used in Ayurvedic medicine that helps the body manage stress. May support testosterone levels, reduce cortisol, and improve recovery and power output.	Reduces stress and cortisol levels; supports hormone balance; may increase strength and recovery; enhances cognitive function under stress	ashwagandha	2025-05-11 02:14:00	2025-05-11 02:14:00
252	PurCaf	An organic caffeine extracted from green coffee beans that provides the stimulant benefits of caffeine from a natural source rather than synthetic production.	Provides clean, natural caffeine; increases energy and alertness; enhances focus; derived from organic coffee	purcaf	2025-05-11 02:14:01	2025-05-11 02:14:01
224	Green Tea Leaf Extract	Contains catechins (particularly EGCG) and a moderate amount of caffeine, supporting fat metabolism, providing antioxidant effects, and offering a milder stimulant effect than synthetic caffeine.	Provides antioxidants; supports metabolism; enhances fat oxidation; moderate caffeine content; cardiovascular benefits	green-tea-leaf-extract	2025-05-11 02:13:59	2025-05-11 02:13:59
234	Potassium Dodecanedioate	\N	\N	potassium-dodecanedioate	2025-05-11 02:14:00	2025-05-11 02:14:00
244	Lion's Mane	A medicinal mushroom that contains compounds that may stimulate nerve growth factor (NGF) production, supporting brain health and cognitive function during exercise.	Supports cognitive function; may enhance focus; neuroprotective properties; potential mood benefits	lion-s-mane	2025-05-11 02:14:01	2025-05-11 02:14:01
254	L-Ornithine Hydrochloride	\N	\N	l-ornithine-hydrochloride	2025-05-11 02:14:02	2025-05-11 02:14:02
225	Nitrosigine	A patented complex of bonded arginine silicate that increases nitric oxide levels for improved blood flow. Designed to provide longer-lasting effects than traditional arginine or citrulline.	Enhances nitric oxide production; improves blood flow; provides sustained pump effect; supports cognitive performance	nitrosigine	2025-05-11 02:13:59	2025-05-11 02:13:59
235	Hemerocallis Fulva	\N	\N	hemerocallis-fulva	2025-05-11 02:14:00	2025-05-11 02:14:00
245	VasoDrive AP	A proprietary ingredient derived from casein hydrolysate containing two lactotripeptides that help relax blood vessels and improve blood flow to working muscles.	Promotes vasodilation; lowers blood pressure; enhances blood flow; improves nutrient delivery	vasodrive-ap	2025-05-11 02:14:01	2025-05-11 02:14:01
255	PEAK ATP	\N	\N	peak-atp	2025-05-11 02:14:02	2025-05-11 02:14:02
226	Glycerol Monostearate	A compound that increases water retention in the bloodstream and tissues, creating a hyperhydration effect that can benefit endurance and create visual fullness to muscles.	Enhances cellular hydration; increases endurance; creates "hyper-hydration" effect; improves muscle fullness	glycerol-monostearate	2025-05-11 02:13:59	2025-05-11 02:13:59
236	Cocoabuterol	\N	\N	cocoabuterol	2025-05-11 02:14:00	2025-05-11 02:14:00
246	Synaptrix	\N	\N	synaptrix	2025-05-11 02:14:01	2025-05-11 02:14:01
256	Zynamite	\N	\N	zynamite	2025-05-11 02:14:02	2025-05-11 02:14:02
227	Nitro Rocket	\N	\N	nitro-rocket	2025-05-11 02:13:59	2025-05-11 02:13:59
237	Caloriburn GP	\N	\N	caloriburn-gp	2025-05-11 02:14:00	2025-05-11 02:14:00
247	Caffeine Citrate	A form of caffeine combined with citric acid that is more water-soluble than regular caffeine, allowing for faster absorption and quicker onset of effects.	Faster-acting caffeine form; quicker onset of alertness and energy; may have improved bioavailability	caffeine-citrate	2025-05-11 02:14:01	2025-05-11 02:14:01
257	Senactiv	A proprietary ingredient containing Panax notoginseng and Rosa roxburghii that has been shown to help clear senescent cells and regenerate damaged muscle cells, potentially improving recovery and performance.	Enhances muscle endurance; accelerates muscle cell regeneration; increases VO2 max; improves recovery	senactiv	2025-05-11 02:14:02	2025-05-11 02:14:02
228	Rauwolfa Vomitoria	\N	\N	rauwolfa-vomitoria	2025-05-11 02:13:59	2025-05-11 02:13:59
238	zumXR	\N	\N	zumxr	2025-05-11 02:14:00	2025-05-11 02:14:00
248	Bitter Orange Extract	\N	\N	bitter-orange-extract	2025-05-11 02:14:01	2025-05-11 02:14:01
258	FitNox	A patented blend of nitric oxide boosting ingredients designed to increase blood flow and enhance exercise performance through improved oxygen and nutrient delivery.	Boosts nitric oxide production; enhances blood flow; improves exercise performance; supports muscle pumps	fitnox	2025-05-11 02:14:02	2025-05-11 02:14:02
229	Aquamin	\N	\N	aquamin	2025-05-11 02:13:59	2025-05-11 02:13:59
239	S7	\N	\N	s7	2025-05-11 02:14:00	2025-05-11 02:14:00
249	Grapefruit Extract	\N	\N	grapefruit-extract	2025-05-11 02:14:01	2025-05-11 02:14:01
259	NooLVL	A patented complex of inositol-stabilized arginine silicate with additional inositol, designed to improve cognitive performance, particularly beneficial for gamers and those needing quick reaction times.	Enhances cognitive function; improves reaction time; increases focus and mental energy; supports gaming performance	noolvl	2025-05-11 02:14:02	2025-05-11 02:14:02
230	BioPerine	A patented extract from black pepper containing piperine, which enhances the bioavailability of many nutrients by inhibiting enzymes that would metabolize them and by enhancing absorption in the intestines.	Enhances nutrient absorption; increases bioavailability of other ingredients; may improve thermogenesis	bioperine	2025-05-11 02:13:59	2025-05-11 02:13:59
240	SaniEnergy Nu	\N	\N	sanienergy-nu	2025-05-11 02:14:00	2025-05-11 02:14:00
250	Synephrine	\N	\N	synephrine	2025-05-11 02:14:01	2025-05-11 02:14:01
260	Rhodiola Rosea	An adaptogenic herb that helps the body adapt to stress and may reduce fatigue. Can enhance physical performance, particularly endurance, and support cognitive function during stressful exercise.	Reduces mental and physical fatigue; enhances stress resistance; improves exercise performance; adaptogenic properties	rhodiola-rosea	2025-05-11 02:14:02	2025-05-11 02:14:02
231	Cognatiq	\N	\N	cognatiq	2025-05-11 02:13:59	2025-05-11 02:13:59
241	MitoBurn	\N	\N	mitoburn	2025-05-11 02:14:00	2025-05-11 02:14:00
251	Citicoline	A compound that provides choline and cytidine, supporting phosphatidylcholine synthesis in the brain. Offers more potent cognitive benefits than standard choline sources.	Enhances brain energy metabolism; improves focus and attention; supports acetylcholine production; neuroprotective effects	citicoline	2025-05-11 02:14:01	2025-05-11 02:14:01
233	Sodium Dodecanedioate	\N	\N	sodium-dodecanedioate	2025-05-11 02:13:59	2025-05-11 02:13:59
243	HydroPrime	A highly concentrated form of glycerol that improves hydration and endurance. Creates a visual "pump" effect and may improve performance in hot conditions or during longer exercise sessions.	Enhanced form of glycerol; improves cellular hydration; increases endurance; creates fuller muscle appearance	hydroprime	2025-05-11 02:14:00	2025-05-11 02:14:00
253	NeuroRush	\N	\N	neurorush	2025-05-11 02:14:01	2025-05-11 02:14:01
271	Glycersize	65% Glycerol Powder	\N	glycersize	2025-05-11 20:55:16	2025-05-11 20:55:16
272	Pine Bark Extract	95% Proanthocyanidins	\N	pine-bark-extract	2025-05-11 20:56:40	2025-05-11 20:56:40
273	Phyt02	\N	\N	phyt02	2025-05-11 20:59:20	2025-05-11 20:59:20
274	Caffeine Natural	From Coffee	\N	caffeine-natural	2025-05-11 21:00:05	2025-05-11 21:00:05
275	Neurofactor	Coffee Fruit Extract	\N	neurofactor	2025-05-11 21:00:38	2025-05-11 21:00:38
276	Methylliberine	\N	\N	methylliberine	2025-05-11 21:08:38	2025-05-11 21:08:38
277	Peak02	\N	\N	peak02	2025-05-11 21:12:03	2025-05-11 21:12:03
280	Dan Shen	\N	\N	dan-shen	2025-05-14 16:30:24	2025-05-14 16:30:24
292	Glycerpump	\N	\N	glycerpump	2025-05-14 22:14:49	2025-05-14 22:14:49
293	Guarana Extract	\N	\N	guarana-extract	2025-05-14 22:15:40	2025-05-14 22:15:40
294	Yerba Mate Extract	\N	\N	yerba-mate-extract	2025-05-14 22:16:15	2025-05-14 22:16:15
295	Inositol Arginine Silicate	\N	\N	inositol-arginine-silicate	2025-05-14 22:19:39	2025-05-14 22:19:39
296	Beet Root Extract	\N	\N	beet-root-extract	2025-05-14 22:20:27	2025-05-14 22:20:27
301	Taurine	\N	\N	taurine	2025-05-18 00:12:42	2025-05-18 00:12:42
302	zumDR	\N	\N	zumdr	2025-05-18 00:14:11	2025-05-18 00:14:11
303	Dendrobium Stem Extract	\N	\N	dendrobium-stem-extract	2025-05-18 01:49:36	2025-05-18 01:49:36
304	Citrus aurantium Extract	\N	\N	citrus-aurantium-extract	2025-05-18 01:50:56	2025-05-18 01:50:56
305	Cluster Dextrin	\N	\N	cluster-dextrin	2025-05-18 01:57:13	2025-05-18 01:57:13
306	Metabolyte	\N	\N	metabolyte	2025-05-18 02:21:17	2025-05-18 02:21:17
307	Dandelion Extract	\N	\N	dandelion-extract	2025-05-18 02:22:46	2025-05-18 02:22:46
308	Raspberry Ketone	\N	\N	raspberry-ketone	2025-05-18 02:23:34	2025-05-18 02:23:34
309	Evodiamine	\N	\N	evodiamine	2025-05-18 02:24:17	2025-05-18 02:24:17
310	Norvaline	\N	\N	norvaline	2025-05-18 02:27:31	2025-05-18 02:27:31
311	Arginine Nitrate	\N	\N	arginine-nitrate	2025-05-24 19:53:25	2025-05-24 19:53:25
312	Grape Seed Extract	\N	\N	grape-seed-extract	2025-05-24 20:09:03	2025-05-24 20:09:03
\.


--
-- Data for Name: product_ingredients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.product_ingredients (id, dosage_unit, product_id, ingredient_id, inserted_at, updated_at, dosage_amount) FROM stdin;
140	mg	44	209	2025-05-14 17:06:21	2025-05-14 17:06:21	200.00
141	g	44	199	2025-05-14 17:06:21	2025-05-14 17:06:21	2.00
142	mg	44	205	2025-05-14 17:06:21	2025-05-14 17:06:21	300.00
143	mg	44	247	2025-05-14 17:06:21	2025-05-14 17:06:21	50.00
144	g	44	206	2025-05-14 17:06:21	2025-05-14 17:06:21	1.00
76	mg	36	230	2025-05-11 21:01:12	2025-05-11 21:01:12	10.00
77	mg	36	274	2025-05-11 21:01:12	2025-05-11 21:01:12	150.00
78	mcg	36	210	2025-05-11 21:01:12	2025-05-11 21:01:12	50.00
79	g	36	202	2025-05-11 21:01:12	2025-05-11 21:01:12	1.00
80	mg	36	275	2025-05-11 21:01:12	2025-05-11 21:01:12	100.00
81	mg	36	273	2025-05-11 21:01:13	2025-05-11 21:01:13	190.00
82	mg	37	230	2025-05-11 21:03:59	2025-05-11 21:03:59	10.00
83	mg	37	274	2025-05-11 21:03:59	2025-05-11 21:03:59	150.00
84	mcg	37	210	2025-05-11 21:03:59	2025-05-11 21:03:59	50.00
85	g	37	202	2025-05-11 21:03:59	2025-05-11 21:03:59	1.00
86	mg	37	275	2025-05-11 21:03:59	2025-05-11 21:03:59	100.00
87	mg	37	273	2025-05-11 21:03:59	2025-05-11 21:03:59	190.00
88	g	40	199	2025-05-11 21:22:23	2025-05-11 21:22:23	3.20
89	g	40	200	2025-05-11 21:22:23	2025-05-11 21:22:23	2.50
90	g	40	197	2025-05-11 21:22:23	2025-05-11 21:22:23	5.00
91	g	40	202	2025-05-11 21:22:23	2025-05-11 21:22:23	1.00
92	g	40	277	2025-05-11 21:22:23	2025-05-11 21:22:23	1.00
93	mg	40	239	2025-05-11 21:22:23	2025-05-11 21:22:23	50.00
94	g	35	213	2025-05-11 21:24:04	2025-05-11 21:24:04	1.00
95	mg	35	209	2025-05-11 21:24:04	2025-05-11 21:24:04	600.00
96	g	35	271	2025-05-11 21:24:04	2025-05-11 21:24:04	2.00
97	mg	35	220	2025-05-11 21:24:04	2025-05-11 21:24:04	250.00
98	mg	35	272	2025-05-11 21:24:04	2025-05-11 21:24:04	150.00
108	mg	41	209	2025-05-14 16:25:55	2025-05-14 16:25:55	200.00
109	g	41	199	2025-05-14 16:25:55	2025-05-14 16:25:55	3.00
110	mg	41	248	2025-05-14 16:25:55	2025-05-14 16:25:55	150.00
111	mg	41	205	2025-05-14 16:25:55	2025-05-14 16:25:55	500.00
112	mg	41	206	2025-05-14 16:25:55	2025-05-14 16:25:55	500.00
113	mg	41	236	2025-05-14 16:25:55	2025-05-14 16:25:55	80.00
114	mcg	41	210	2025-05-14 16:25:55	2025-05-14 16:25:55	50.00
115	g	41	198	2025-05-14 16:25:55	2025-05-14 16:25:55	4.00
116	g	41	201	2025-05-14 16:25:55	2025-05-14 16:25:55	2.00
117	mg	41	202	2025-05-14 16:25:55	2025-05-14 16:25:55	750.00
123	mg	42	230	2025-05-14 16:31:21	2025-05-14 16:31:21	5.00
124	mg	42	280	2025-05-14 16:31:21	2025-05-14 16:31:21	100.00
125	g	42	271	2025-05-14 16:31:21	2025-05-14 16:31:21	2.00
126	g	42	198	2025-05-14 16:31:21	2025-05-14 16:31:21	5.00
127	g	42	201	2025-05-14 16:31:21	2025-05-14 16:31:21	2.00
128	mg	42	225	2025-05-14 16:31:21	2025-05-14 16:31:21	500.00
129	mg	43	209	2025-05-14 17:01:34	2025-05-14 17:01:34	300.00
130	g	43	199	2025-05-14 17:01:34	2025-05-14 17:01:34	1.60
131	g	43	200	2025-05-14 17:01:34	2025-05-14 17:01:34	2.50
132	mg	43	205	2025-05-14 17:01:34	2025-05-14 17:01:34	300.00
133	mg	43	247	2025-05-14 17:01:34	2025-05-14 17:01:34	50.00
134	g	43	197	2025-05-14 17:01:34	2025-05-14 17:01:34	2.50
135	mcg	43	210	2025-05-14 17:01:34	2025-05-14 17:01:34	400.00
136	g	43	243	2025-05-14 17:01:34	2025-05-14 17:01:34	1.00
137	g	43	198	2025-05-14 17:01:34	2025-05-14 17:01:34	5.00
138	g	43	201	2025-05-14 17:01:34	2025-05-14 17:01:34	2.00
139	g	43	202	2025-05-14 17:01:34	2025-05-14 17:01:34	1.00
145	mg	44	197	2025-05-14 17:06:21	2025-05-14 17:06:21	5.00
146	mg	44	216	2025-05-14 17:06:21	2025-05-14 17:06:21	50.00
147	mcg	44	210	2025-05-14 17:06:21	2025-05-14 17:06:21	400.00
148	g	44	243	2025-05-14 17:06:21	2025-05-14 17:06:21	2.00
149	g	44	198	2025-05-14 17:06:21	2025-05-14 17:06:21	8.00
150	mg	44	244	2025-05-14 17:06:21	2025-05-14 17:06:21	600.00
151	mg	44	254	2025-05-14 17:06:21	2025-05-14 17:06:21	400.00
152	g	44	201	2025-05-14 17:06:22	2025-05-14 17:06:22	2.00
153	g	44	225	2025-05-14 17:06:22	2025-05-14 17:06:22	1.00
154	mg	45	205	2025-05-14 22:11:33	2025-05-14 22:11:33	100.00
155	g	45	197	2025-05-14 22:11:33	2025-05-14 22:11:33	2.50
156	mg	45	259	2025-05-14 22:11:33	2025-05-14 22:11:33	800.00
157	mg	45	260	2025-05-14 22:11:33	2025-05-14 22:11:33	75.00
158	mg	45	257	2025-05-14 22:11:33	2025-05-14 22:11:33	25.00
159	mg	46	209	2025-05-14 22:17:21	2025-05-14 22:17:21	400.00
160	g	46	199	2025-05-14 22:17:21	2025-05-14 22:17:21	3.00
161	g	46	200	2025-05-14 22:17:21	2025-05-14 22:17:21	2.50
162	mg	46	205	2025-05-14 22:17:21	2025-05-14 22:17:21	200.00
163	g	46	292	2025-05-14 22:17:21	2025-05-14 22:17:21	1.00
164	mg	46	293	2025-05-14 22:17:21	2025-05-14 22:17:21	100.00
165	g	46	198	2025-05-14 22:17:21	2025-05-14 22:17:21	6.00
166	g	46	201	2025-05-14 22:17:21	2025-05-14 22:17:21	2.00
167	mg	46	204	2025-05-14 22:17:21	2025-05-14 22:17:21	250.00
168	mg	46	208	2025-05-14 22:17:21	2025-05-14 22:17:21	100.00
169	mg	46	294	2025-05-14 22:17:22	2025-05-14 22:17:22	100.00
170	g	47	213	2025-05-14 22:20:57	2025-05-14 22:20:57	1.25
171	mg	47	296	2025-05-14 22:20:57	2025-05-14 22:20:57	125.00
172	g	47	200	2025-05-14 22:20:58	2025-05-14 22:20:58	1.00
173	mg	47	230	2025-05-14 22:20:58	2025-05-14 22:20:58	5.00
174	mg	47	292	2025-05-14 22:20:58	2025-05-14 22:20:58	750.00
175	g	47	295	2025-05-14 22:20:58	2025-05-14 22:20:58	1.50
176	g	47	198	2025-05-14 22:20:58	2025-05-14 22:20:58	8.00
177	mg	47	239	2025-05-14 22:20:58	2025-05-14 22:20:58	75.00
188	g	50	198	2025-05-18 00:15:36	2025-05-18 00:15:36	4.00
189	g	50	199	2025-05-18 00:15:36	2025-05-18 00:15:36	3.20
190	mg	50	242	2025-05-18 00:15:36	2025-05-18 00:15:36	250.00
191	mg	50	237	2025-05-18 00:15:36	2025-05-18 00:15:36	40.00
192	mg	50	230	2025-05-18 00:15:36	2025-05-18 00:15:36	10.00
193	mg	50	223	2025-05-18 00:15:36	2025-05-18 00:15:36	5.00
194	mg	50	228	2025-05-18 00:15:37	2025-05-18 00:15:37	1.00
195	g	50	206	2025-05-18 00:15:37	2025-05-18 00:15:37	1.00
196	g	50	202	2025-05-18 00:15:37	2025-05-18 00:15:37	1.00
197	mg	50	301	2025-05-18 00:15:37	2025-05-18 00:15:37	500.00
198	mg	50	241	2025-05-18 00:15:37	2025-05-18 00:15:37	500.00
199	mg	50	240	2025-05-18 00:15:37	2025-05-18 00:15:37	400.00
200	mg	50	205	2025-05-18 00:15:37	2025-05-18 00:15:37	260.00
201	mg	50	238	2025-05-18 00:15:37	2025-05-18 00:15:37	30.00
202	mg	50	302	2025-05-18 00:15:37	2025-05-18 00:15:37	30.00
203	g	51	198	2025-05-18 00:18:48	2025-05-18 00:18:48	4.00
204	g	51	199	2025-05-18 00:18:48	2025-05-18 00:18:48	3.20
205	mg	51	230	2025-05-18 00:18:48	2025-05-18 00:18:48	10.00
206	g	51	200	2025-05-18 00:18:49	2025-05-18 00:18:49	2.50
207	g	51	202	2025-05-18 00:18:49	2025-05-18 00:18:49	1.50
208	g	51	301	2025-05-18 00:18:49	2025-05-18 00:18:49	1.00
209	mg	51	240	2025-05-18 00:18:49	2025-05-18 00:18:49	400.00
210	mg	51	205	2025-05-18 00:18:49	2025-05-18 00:18:49	275.00
211	mg	51	238	2025-05-18 00:18:49	2025-05-18 00:18:49	30.00
212	mg	51	302	2025-05-18 00:18:49	2025-05-18 00:18:49	20.00
213	mg	51	239	2025-05-18 00:18:49	2025-05-18 00:18:49	50.00
214	g	52	198	2025-05-18 00:21:56	2025-05-18 00:21:56	4.00
215	g	52	199	2025-05-18 00:21:56	2025-05-18 00:21:56	3.20
216	mg	52	239	2025-05-18 00:21:56	2025-05-18 00:21:56	50.00
217	mg	52	210	2025-05-18 00:21:56	2025-05-18 00:21:56	20.00
218	mg	52	230	2025-05-18 00:21:56	2025-05-18 00:21:56	10.00
219	mg	52	228	2025-05-18 00:21:56	2025-05-18 00:21:56	1.00
220	g	52	200	2025-05-18 00:21:56	2025-05-18 00:21:56	2.50
221	g	52	202	2025-05-18 00:21:56	2025-05-18 00:21:56	1.00
222	g	52	301	2025-05-18 00:21:56	2025-05-18 00:21:56	1.00
223	mg	52	240	2025-05-18 00:21:57	2025-05-18 00:21:57	400.00
224	mg	52	205	2025-05-18 00:21:57	2025-05-18 00:21:57	320.00
225	mg	52	238	2025-05-18 00:21:57	2025-05-18 00:21:57	35.00
226	mg	52	302	2025-05-18 00:21:57	2025-05-18 00:21:57	15.00
227	mg	52	276	2025-05-18 00:21:57	2025-05-18 00:21:57	100.00
228	g	53	198	2025-05-18 00:24:13	2025-05-18 00:24:13	8.00
229	g	53	199	2025-05-18 00:24:13	2025-05-18 00:24:13	3.50
230	g	53	243	2025-05-18 00:24:13	2025-05-18 00:24:13	3.00
231	mg	53	244	2025-05-18 00:24:13	2025-05-18 00:24:13	600.00
232	mg	53	209	2025-05-18 00:24:13	2025-05-18 00:24:13	300.00
233	mg	53	239	2025-05-18 00:24:13	2025-05-18 00:24:13	150.00
234	mg	53	211	2025-05-18 00:24:13	2025-05-18 00:24:13	50.00
235	mg	53	210	2025-05-18 00:24:13	2025-05-18 00:24:13	20.00
236	g	54	198	2025-05-18 00:26:36	2025-05-18 00:26:36	3.00
237	g	54	197	2025-05-18 00:26:36	2025-05-18 00:26:36	2.50
238	g	54	199	2025-05-18 00:26:36	2025-05-18 00:26:36	1.60
239	mg	54	301	2025-05-18 00:26:36	2025-05-18 00:26:36	500.00
240	mg	54	205	2025-05-18 00:26:36	2025-05-18 00:26:36	150.50
241	mg	54	238	2025-05-18 00:26:36	2025-05-18 00:26:36	10.00
242	mg	54	302	2025-05-18 00:26:36	2025-05-18 00:26:36	5.00
243	g	55	198	2025-05-18 01:51:03	2025-05-18 01:51:03	6.50
244	g	55	199	2025-05-18 01:51:03	2025-05-18 01:51:03	4.00
245	mg	55	303	2025-05-18 01:51:03	2025-05-18 01:51:03	300.00
246	mcg	55	210	2025-05-18 01:51:03	2025-05-18 01:51:03	300.00
247	mg	55	304	2025-05-18 01:51:03	2025-05-18 01:51:03	30.00
248	g	55	202	2025-05-18 01:51:03	2025-05-18 01:51:03	1.50
249	g	55	200	2025-05-18 01:51:03	2025-05-18 01:51:03	4.00
250	g	55	213	2025-05-18 01:51:03	2025-05-18 01:51:03	1.00
251	mg	55	209	2025-05-18 01:51:04	2025-05-18 01:51:04	600.00
252	mg	55	205	2025-05-18 01:51:04	2025-05-18 01:51:04	325.00
253	mg	55	208	2025-05-18 01:51:04	2025-05-18 01:51:04	300.00
254	mg	55	219	2025-05-18 01:51:04	2025-05-18 01:51:04	150.00
255	mg	55	274	2025-05-18 01:51:04	2025-05-18 01:51:04	125.00
256	g	56	198	2025-05-18 01:57:25	2025-05-18 01:57:25	4.00
257	g	56	200	2025-05-18 01:57:25	2025-05-18 01:57:25	2.00
258	g	56	199	2025-05-18 01:57:25	2025-05-18 01:57:25	1.50
259	g	56	203	2025-05-18 01:57:25	2025-05-18 01:57:25	1.00
260	mg	56	225	2025-05-18 01:57:25	2025-05-18 01:57:25	500.00
261	mg	56	205	2025-05-18 01:57:25	2025-05-18 01:57:25	395.00
262	mg	56	228	2025-05-18 01:57:25	2025-05-18 01:57:25	2.00
263	mcg	56	210	2025-05-18 01:57:25	2025-05-18 01:57:25	150.00
264	g	56	305	2025-05-18 01:57:25	2025-05-18 01:57:25	1.00
265	g	57	198	2025-05-18 02:09:53	2025-05-18 02:09:53	9.00
266	g	57	199	2025-05-18 02:09:53	2025-05-18 02:09:53	5.00
267	mg	57	274	2025-05-18 02:09:53	2025-05-18 02:09:53	175.00
268	mg	57	238	2025-05-18 02:09:53	2025-05-18 02:09:53	50.00
269	g	57	200	2025-05-18 02:09:53	2025-05-18 02:09:53	5.00
270	g	57	197	2025-05-18 02:09:53	2025-05-18 02:09:53	5.00
271	g	57	209	2025-05-18 02:09:54	2025-05-18 02:09:54	1.20
272	g	57	225	2025-05-18 02:09:54	2025-05-18 02:09:54	1.00
273	mg	57	204	2025-05-18 02:09:54	2025-05-18 02:09:54	500.00
274	mg	57	245	2025-05-18 02:09:54	2025-05-18 02:09:54	254.00
275	mg	57	208	2025-05-18 02:09:54	2025-05-18 02:09:54	200.00
276	mg	57	205	2025-05-18 02:09:54	2025-05-18 02:09:54	175.00
277	g	58	198	2025-05-18 02:12:19	2025-05-18 02:12:19	9.00
278	g	58	199	2025-05-18 02:12:19	2025-05-18 02:12:19	5.00
279	mg	58	238	2025-05-18 02:12:19	2025-05-18 02:12:19	25.00
280	g	58	200	2025-05-18 02:12:19	2025-05-18 02:12:19	5.00
281	g	58	197	2025-05-18 02:12:19	2025-05-18 02:12:19	5.00
282	g	58	209	2025-05-18 02:12:19	2025-05-18 02:12:19	1.20
283	g	58	225	2025-05-18 02:12:19	2025-05-18 02:12:19	1.00
284	mg	58	204	2025-05-18 02:12:19	2025-05-18 02:12:19	500.00
285	mg	58	245	2025-05-18 02:12:19	2025-05-18 02:12:19	254.00
286	mg	58	208	2025-05-18 02:12:20	2025-05-18 02:12:20	200.00
287	mg	58	205	2025-05-18 02:12:20	2025-05-18 02:12:20	200.00
302	g	60	198	2025-05-18 02:19:49	2025-05-18 02:19:49	3.00
303	g	60	199	2025-05-18 02:19:49	2025-05-18 02:19:49	3.00
304	mg	60	224	2025-05-18 02:19:50	2025-05-18 02:19:50	30.00
305	mg	60	228	2025-05-18 02:19:50	2025-05-18 02:19:50	1.00
306	mg	60	214	2025-05-18 02:19:50	2025-05-18 02:19:50	1.00
307	mcg	60	210	2025-05-18 02:19:50	2025-05-18 02:19:50	100.00
308	g	60	200	2025-05-18 02:19:50	2025-05-18 02:19:50	2.00
309	g	60	202	2025-05-18 02:19:50	2025-05-18 02:19:50	1.25
310	mg	60	225	2025-05-18 02:19:50	2025-05-18 02:19:50	750.00
311	mg	60	204	2025-05-18 02:19:50	2025-05-18 02:19:50	350.00
312	mg	60	205	2025-05-18 02:19:50	2025-05-18 02:19:50	325.00
313	mg	60	244	2025-05-18 02:19:50	2025-05-18 02:19:50	300.00
314	mg	60	208	2025-05-18 02:19:50	2025-05-18 02:19:50	150.00
315	mg	60	216	2025-05-18 02:19:50	2025-05-18 02:19:50	75.00
316	g	61	198	2025-05-18 02:25:17	2025-05-18 02:25:17	8.00
317	g	61	199	2025-05-18 02:25:17	2025-05-18 02:25:17	3.20
318	mg	61	307	2025-05-18 02:25:17	2025-05-18 02:25:17	500.00
319	mg	61	308	2025-05-18 02:25:17	2025-05-18 02:25:17	250.00
320	mg	61	309	2025-05-18 02:25:17	2025-05-18 02:25:17	60.00
321	mg	61	223	2025-05-18 02:25:17	2025-05-18 02:25:17	20.00
322	mg	61	230	2025-05-18 02:25:18	2025-05-18 02:25:18	5.00
323	mg	61	232	2025-05-18 02:25:18	2025-05-18 02:25:18	500.00
324	mg	61	205	2025-05-18 02:25:18	2025-05-18 02:25:18	350.00
325	mg	61	206	2025-05-18 02:25:18	2025-05-18 02:25:18	300.00
326	mg	61	248	2025-05-18 02:25:18	2025-05-18 02:25:18	130.00
327	mg	61	274	2025-05-18 02:25:18	2025-05-18 02:25:18	100.00
328	mg	61	249	2025-05-18 02:25:18	2025-05-18 02:25:18	100.00
329	mg	61	222	2025-05-18 02:25:18	2025-05-18 02:25:18	75.00
330	g	61	306	2025-05-18 02:25:18	2025-05-18 02:25:18	2.00
331	g	62	198	2025-05-18 02:27:38	2025-05-18 02:27:38	6.00
332	g	62	200	2025-05-18 02:27:38	2025-05-18 02:27:38	2.50
333	g	62	271	2025-05-18 02:27:38	2025-05-18 02:27:38	2.00
334	mg	62	199	2025-05-18 02:27:38	2025-05-18 02:27:38	1.50
335	g	62	225	2025-05-18 02:27:38	2025-05-18 02:27:38	1.20
336	mg	62	213	2025-05-18 02:27:38	2025-05-18 02:27:38	500.00
337	mg	62	310	2025-05-18 02:27:38	2025-05-18 02:27:38	250.00
338	g	63	198	2025-05-18 02:29:11	2025-05-18 02:29:11	4.00
339	g	63	200	2025-05-18 02:29:11	2025-05-18 02:29:11	2.00
340	g	63	199	2025-05-18 02:29:11	2025-05-18 02:29:11	1.50
341	g	63	305	2025-05-18 02:29:11	2025-05-18 02:29:11	1.00
342	g	63	203	2025-05-18 02:29:11	2025-05-18 02:29:11	1.00
343	mg	63	225	2025-05-18 02:29:11	2025-05-18 02:29:11	500.00
344	g	64	198	2025-05-24 18:51:36	2025-05-24 18:51:36	6.00
345	g	64	199	2025-05-24 18:51:36	2025-05-24 18:51:36	2.50
346	mg	64	257	2025-05-24 18:51:36	2025-05-24 18:51:36	25.00
347	g	64	201	2025-05-24 18:51:36	2025-05-24 18:51:36	1.00
348	g	64	202	2025-05-24 18:51:37	2025-05-24 18:51:37	1.00
349	mg	64	206	2025-05-24 18:51:37	2025-05-24 18:51:37	300.00
350	mg	64	207	2025-05-24 18:51:37	2025-05-24 18:51:37	50.00
351	mcg	64	210	2025-05-24 18:51:37	2025-05-24 18:51:37	100.00
352	mg	64	205	2025-05-24 18:51:37	2025-05-24 18:51:37	300.00
353	mg	64	239	2025-05-24 18:51:37	2025-05-24 18:51:37	200.00
354	mg	64	211	2025-05-24 18:51:37	2025-05-24 18:51:37	25.00
355	g	65	198	2025-05-24 18:55:43	2025-05-24 18:55:43	3.00
356	mg	65	225	2025-05-24 18:55:44	2025-05-24 18:55:44	750.00
357	g	65	199	2025-05-24 18:55:44	2025-05-24 18:55:44	1.60
358	g	65	200	2025-05-24 18:55:44	2025-05-24 18:55:44	1.25
359	g	65	201	2025-05-24 18:55:44	2025-05-24 18:55:44	1.00
360	g	65	202	2025-05-24 18:55:44	2025-05-24 18:55:44	1.00
361	g	66	198	2025-05-24 18:57:52	2025-05-24 18:57:52	6.00
362	g	66	199	2025-05-24 18:57:52	2025-05-24 18:57:52	2.00
363	g	66	202	2025-05-24 18:57:52	2025-05-24 18:57:52	1.00
364	mg	66	205	2025-05-24 18:57:52	2025-05-24 18:57:52	350.00
365	g	67	198	2025-05-24 19:42:10	2025-05-24 19:42:10	3.00
366	g	67	254	2025-05-24 19:42:10	2025-05-24 19:42:10	2.00
367	g	67	199	2025-05-24 19:42:10	2025-05-24 19:42:10	1.60
368	g	67	200	2025-05-24 19:42:11	2025-05-24 19:42:11	1.25
369	g	67	301	2025-05-24 19:42:11	2025-05-24 19:42:11	1.00
370	mg	67	202	2025-05-24 19:42:11	2025-05-24 19:42:11	750.00
371	mg	67	251	2025-05-24 19:42:11	2025-05-24 19:42:11	250.00
372	mg	67	274	2025-05-24 19:42:11	2025-05-24 19:42:11	150.00
373	mg	67	253	2025-05-24 19:42:11	2025-05-24 19:42:11	50.00
374	g	68	198	2025-05-24 19:44:49	2025-05-24 19:44:49	3.00
375	g	68	254	2025-05-24 19:44:49	2025-05-24 19:44:49	2.00
376	g	68	199	2025-05-24 19:44:49	2025-05-24 19:44:49	1.60
377	g	68	200	2025-05-24 19:44:49	2025-05-24 19:44:49	1.25
378	g	68	301	2025-05-24 19:44:49	2025-05-24 19:44:49	1.00
379	mg	68	202	2025-05-24 19:44:49	2025-05-24 19:44:49	750.00
380	mg	68	251	2025-05-24 19:44:49	2025-05-24 19:44:49	250.00
381	mg	68	255	2025-05-24 19:44:49	2025-05-24 19:44:49	200.00
382	mg	68	253	2025-05-24 19:44:49	2025-05-24 19:44:49	50.00
383	g	69	198	2025-05-24 19:47:45	2025-05-24 19:47:45	6.00
384	g	69	199	2025-05-24 19:47:45	2025-05-24 19:47:45	3.00
385	mg	69	211	2025-05-24 19:47:45	2025-05-24 19:47:45	50.00
386	mcg	69	210	2025-05-24 19:47:45	2025-05-24 19:47:45	90.00
387	mg	69	205	2025-05-24 19:47:45	2025-05-24 19:47:45	350.00
388	mg	69	206	2025-05-24 19:47:46	2025-05-24 19:47:46	250.00
389	mg	69	202	2025-05-24 19:47:46	2025-05-24 19:47:46	200.00
390	mg	69	204	2025-05-24 19:47:46	2025-05-24 19:47:46	200.00
391	mg	69	301	2025-05-24 19:47:46	2025-05-24 19:47:46	200.00
392	mg	69	256	2025-05-24 19:47:46	2025-05-24 19:47:46	140.00
393	mg	69	276	2025-05-24 19:47:46	2025-05-24 19:47:46	100.00
394	mg	69	257	2025-05-24 19:47:46	2025-05-24 19:47:46	50.00
395	g	70	198	2025-05-24 19:54:55	2025-05-24 19:54:55	5.00
396	g	70	199	2025-05-24 19:54:55	2025-05-24 19:54:55	3.20
397	mg	70	257	2025-05-24 19:54:55	2025-05-24 19:54:55	50.00
398	mg	70	211	2025-05-24 19:54:55	2025-05-24 19:54:55	25.00
399	g	70	200	2025-05-24 19:54:55	2025-05-24 19:54:55	2.50
400	g	70	301	2025-05-24 19:54:55	2025-05-24 19:54:55	1.50
401	g	70	202	2025-05-24 19:54:55	2025-05-24 19:54:55	1.50
402	mg	70	209	2025-05-24 19:54:55	2025-05-24 19:54:55	400.00
403	g	70	311	2025-05-24 19:54:55	2025-05-24 19:54:55	2.10
404	mg	70	208	2025-05-24 19:54:55	2025-05-24 19:54:55	300.00
405	mg	70	205	2025-05-24 19:54:55	2025-05-24 19:54:55	175.00
406	mg	70	216	2025-05-24 19:54:55	2025-05-24 19:54:55	100.00
407	g	71	198	2025-05-24 20:03:15	2025-05-24 20:03:15	4.00
408	g	71	199	2025-05-24 20:03:15	2025-05-24 20:03:15	1.60
409	g	71	311	2025-05-24 20:03:15	2025-05-24 20:03:15	1.50
410	g	71	200	2025-05-24 20:03:15	2025-05-24 20:03:15	1.25
411	g	71	202	2025-05-24 20:03:15	2025-05-24 20:03:15	1.00
412	mg	71	208	2025-05-24 20:03:15	2025-05-24 20:03:15	150.00
413	mg	71	205	2025-05-24 20:03:15	2025-05-24 20:03:15	137.50
414	mg	71	251	2025-05-24 20:03:15	2025-05-24 20:03:15	125.00
415	mg	71	216	2025-05-24 20:03:15	2025-05-24 20:03:15	50.00
416	mg	71	211	2025-05-24 20:03:15	2025-05-24 20:03:15	25.00
417	g	72	198	2025-05-24 20:09:32	2025-05-24 20:09:32	5.00
418	g	72	311	2025-05-24 20:09:32	2025-05-24 20:09:32	2.10
419	g	72	199	2025-05-24 20:09:33	2025-05-24 20:09:33	1.60
420	g	72	202	2025-05-24 20:09:33	2025-05-24 20:09:33	1.50
421	g	72	200	2025-05-24 20:09:33	2025-05-24 20:09:33	1.25
422	mg	72	209	2025-05-24 20:09:33	2025-05-24 20:09:33	400.00
423	mg	72	312	2025-05-24 20:09:33	2025-05-24 20:09:33	200.00
424	mg	72	231	2025-05-24 20:09:33	2025-05-24 20:09:33	50.00
425	mg	72	211	2025-05-24 20:09:33	2025-05-24 20:09:33	25.00
426	g	73	198	2025-05-24 20:11:32	2025-05-24 20:11:32	5.00
427	g	73	311	2025-05-24 20:11:32	2025-05-24 20:11:32	1.50
428	g	73	301	2025-05-24 20:11:32	2025-05-24 20:11:32	1.00
429	mg	73	245	2025-05-24 20:11:32	2025-05-24 20:11:32	508.00
430	mg	73	312	2025-05-24 20:11:32	2025-05-24 20:11:32	200.00
431	mg	73	211	2025-05-24 20:11:32	2025-05-24 20:11:32	25.00
432	g	74	198	2025-05-24 20:14:33	2025-05-24 20:14:33	10.00
433	g	74	199	2025-05-24 20:14:33	2025-05-24 20:14:33	4.00
434	mcg	74	210	2025-05-24 20:14:33	2025-05-24 20:14:33	400.00
435	g	74	202	2025-05-24 20:14:33	2025-05-24 20:14:33	3.00
436	g	74	301	2025-05-24 20:14:33	2025-05-24 20:14:33	3.00
437	g	74	200	2025-05-24 20:14:33	2025-05-24 20:14:33	3.00
438	g	74	311	2025-05-24 20:14:33	2025-05-24 20:14:33	2.00
439	mg	74	209	2025-05-24 20:14:34	2025-05-24 20:14:34	600.00
440	mg	74	208	2025-05-24 20:14:34	2025-05-24 20:14:34	400.00
441	mg	74	205	2025-05-24 20:14:34	2025-05-24 20:14:34	400.00
442	mg	74	211	2025-05-24 20:14:34	2025-05-24 20:14:34	50.00
443	g	75	198	2025-05-24 20:16:42	2025-05-24 20:16:42	6.00
444	g	75	199	2025-05-24 20:16:42	2025-05-24 20:16:42	3.20
445	g	75	200	2025-05-24 20:16:42	2025-05-24 20:16:42	2.50
446	g	75	202	2025-05-24 20:16:42	2025-05-24 20:16:42	2.00
447	mg	75	205	2025-05-24 20:16:42	2025-05-24 20:16:42	300.00
448	mg	75	211	2025-05-24 20:16:42	2025-05-24 20:16:42	50.00
449	mcg	75	210	2025-05-24 20:16:42	2025-05-24 20:16:42	400.00
\.


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.products (id, name, description, url, image_url, price, serving_size, servings_per_container, weight_in_grams, is_active, slug, search_vector, brand_id, inserted_at, updated_at) FROM stdin;
35	AlphaSurge	AlphaSurge isn’t just another typical nitric oxide “pump” product. Specifically formulated by athletes for athletes looking to expand and explode their training levels, AlphaSurge was precisely engineered with a hand-selected blend of ingredients that work together to help volumize your muscle cells and improve nutrient delivery.* This helps boost your training and promotes skin-tearing pumps in the gym!*\r\n\r\nThe ingredients of AlphaSurge were distinctively combined to help release nutrients and rich blood flowing directly to your muscle cells during your workout to help with training duration. This is achieved by drawing blood into the muscle – shuttling glycogen and nutrients to the cell membrane – forcing the muscle cells to expand. This process acts as an anabolic signal that helps trigger increased protein synthesis, glycogen uptake, muscular growth, and repair speeds.*\r\n\r\nThe ingredients of AlphaSurge help with the evacuation of acid buildup in the muscles to keep the burn away and fight off muscle fatigue. You’ll immediately feel the increased muscle density and improvements in strength and athletic performance.	https://1stphorm.com/products/alphasurge	https://1stphorm.com/cdn/shop/files/alphasurge-berry-lemonade_720x.png?v=1695160362	45.99	9.5	20	190	t	alphasurge	\N	71	2025-05-11 20:56:59	2025-05-11 21:24:04
36	Megawatt Natural	The dreaded early morning or late afternoon drag you experience before hitting the gym is a thing of the past. We know you will never stop improving... and neither will we! Megawatt has been formulated with natural caffeine and electrolytes to help give you the boost you need to hit your workouts at full speed.\r\n\r\nThe complete mental focus and fortitude you’ll experience will have you pushing past barriers and performing at your peak.\r\n\r\nOur goal is to provide you with an amazing tasting pre-workout that is versatile, so you can use it for any type of athletic activity. Megawatt contains a specific blend of ingredients to give you incredible energy and mental focus like you’ve never experienced before.\r\n\r\nThe research-supported ingredients found in Megawatt also include B vitamins and nootropic ingredients that will help increase mental focus, alertness, and have you dialed in, so you’re going harder in each training session.\r\n\r\nElectrolytes are intertwined with all fluids in the body, and a lack of electrolytes can lead to less-than-peak performance. The blend of Aquamin electrolytes in Megawatt is designed to keep you performing at an optimal level throughout your training session by delaying exercise-induced muscle fatigue, and improving mental capacity to help you push through the most grueling parts of your workout.	https://1stphorm.com/products/megawatt-natural	https://1stphorm.com/cdn/shop/files/megawatt-natural-strawberry-lemonade_1800x1800.png?v=1694545056	46.99	6	40	240	t	megawatt-natural	\N	71	2025-05-11 21:01:12	2025-05-11 21:01:12
37	Megawatt	The dreaded early morning or late afternoon drag before hitting the gym is a thing of the past. We know you will never stop improving ... and neither will we! Megawatt has been formulated with natural caffeine and electrolytes to help give you the boost you need to hit your workouts at full speed.\r\n\r\nThe complete mental focus and fortitude you’ll experience will have you pushing past barriers and performing at your peak.\r\n\r\nOur goal is to provide you with an amazing-tasting pre-workout that is versatile, so you can use it for any type of athletic activity. Megawatt contains a blend of ingredients to give you energy and mental focus like you’ve never experienced before.\r\n\r\nThe research-supported ingredients found in Megawatt also include B vitamins and nootropics. This can further help increase mental focus, alertness, and have you dialed in, so you’re going harder in each training session.\r\n\r\nElectrolytes are intertwined with all fluids in the body. A lack of electrolytes can lead to lower levels of performance. The blend of Aquamin electrolytes in Megawatt is designed to keep you performing at an optimal level throughout your training session by delaying exercise-induced muscle fatigue and improving mental capacity. You'll be able to push through even the most grueling of workouts!	https://1stphorm.com/products/megawatt	https://1stphorm.com/cdn/shop/files/megawatt-pineapple-pomegranate_1800x1800.png?v=1730827019	46.99	5.5	40	220	t	megawatt	\N	71	2025-05-11 21:03:59	2025-05-11 21:03:59
56	Nuclear Armageddon	Nuclear Armageddon gives you the feeling of explosive energy and performance. It's loaded with 395 mg of caffeine and 10 grams of Pump Activators.	https://anabolicwarfare.defynedbrands.com/products/nuclear-armageddon-1	https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWNARBBL_150.029.02_v1.3_Render.png?v=1743516802&width=1800&crop=center	44.99	12.8	30	384	t	nuclear-armageddon	\N	11	2025-05-18 01:57:25	2025-05-18 01:57:25
58	Defcon3	War is hell, but your workout doesn't have to be with DEFCON3! This all-in-one, mid-stim pre-workout supports optimal strength, energy, and performance, without the jitters.	https://anabolicwarfare.defynedbrands.com/products/defcon3	https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWDEFCON3BBL_200.006.01_v2.3_Render.png?v=1743516711&width=1800&crop=center	59.99	30.9	20	618	t	defcon3	\N	11	2025-05-18 02:12:19	2025-05-18 02:12:19
60	Maniac	Train at peak performance with Maniac pre-workout powder. This highly potent comprehensive pre-workout blend is perfect for men and women who want crazy energy and razor-sharp focus!	https://anabolicwarfare.defynedbrands.com/products/anabolic-warfare-black-series-maniac	https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWBLKMANIACAA_150.026.02_v1.6_Render.png?v=1743516727&width=1800&crop=center	49.99	14.5	25	362	t	maniac	\N	11	2025-05-18 02:19:49	2025-05-18 02:19:49
62	Veiniac	Mega-Dosed Muscle Pump Accelerator	https://anabolicwarfare.defynedbrands.com/products/black-series-veiniac	https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWBLKVEINIACFS_100.026.01_v2.3_Render.png?v=1743516725&width=1800&crop=center	49.99	17.4	20	348	t	veiniac	\N	11	2025-05-18 02:27:38	2025-05-18 02:27:38
63	Pump N Grow	Stimulant-free pump and endurance activator.	https://anabolicwarfare.defynedbrands.com/products/pump-n-grow	https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWPUMPNA_150.088.02_v1.2_Render_d3d95adf-a2d3-4234-9eaf-425acbe3e21e.png?v=1743516817&width=1800&crop=center	46.99	11.5	30	345	t	pump-n-grow	\N	11	2025-05-18 02:29:11	2025-05-18 02:29:11
40	Endura-Formance	With each intense rep of your training, you are working towards your goal of becoming a stronger high-performance athlete! But when it comes to muscle growth and sports performance, how you fuel your training makes an enormous impact on your overall results. The ability to energize your muscle fibers with more power and stamina will allow you to train harder and longer. Endura-Formance accomplishes this by combining two powerful clinically proven muscle performance ingredients, creatine and beta-alanine, along with a comprehensive combination of well-studied nutrient and oxygen delivery enhancement compounds, so you can take your strength, power and sports endurance to its peak!\r\n\r\nCreatine is an energy source found naturally in the human body to fight off muscle fatigue and increase the maximal force production of your muscles during intense training by allowing for optimal ATP energy regeneration. Effective supplementation with creatine and beta-alanine, an amino acid derivative aimed specifically at increasing your body’s carnosine levels, has been shown to reduce lactic acid to resist muscle fatigue and improve muscle endurance.\r\n\r\nTo further increase muscle performance and stamina, Endura- Formance includes a powerful blend of betaine anhydrous, Peak02™️, and S7® ingredients. This combination increases muscle hydration and allows your body to maximize oxygen and nutrient delivery to the muscle. This creates a synergistic effect to further protect against muscle fatigue, enhance muscle power output, and endurance so you can train harder and longer.\r\n\r\nThe well-rounded and robust formulation of Endura-Formance will increase aerobic capacity and endurance, as well as your anaerobic power output and overall strength levels making it an ideal supplement for all types of athletes.	https://1stphorm.com/products/endura-formance	https://1stphorm.com/cdn/shop/files/endura-formance-strawberry-pineapple_1800x1800.png?v=1705439207	46.99	16.2	30	480	t	endura-formance	\N	71	2025-05-11 21:22:23	2025-05-11 21:22:23
41	5150	5150 High Stimulant Pre-Workout delivers a supercharged punch with over 400mg of Caffeine per serving, plus the revolutionary energy and nootropic Cocoabuterol for more than 500mg of total stimulant per serving! With just a single scoop of 5150® you'll surge with over 400mg of caffeine through your veins. Our precise 'STIM-JUNKIE' complex combines 8 types of caffeine for a smooth, extended energy curve while nearly eliminating the caffeine jitters or crash that accompany most pre-workouts.	https://5percentnutrition.com/products/5150-high-stimulant-pre-workout	https://5percentnutrition.com/cdn/shop/files/5150_GreenApple_WEB.png?v=1746626137&width=1400	48.99	14.9	30	402	t	5150	\N	23	2025-05-14 16:23:19	2025-05-14 16:25:54
42	Full as F*ck	Your working muscles feel like they’re about to explode, not to mention looking absolutely huge. There’s no doubt that a great pump can transform your physique right before your eyes. A pump like this forces your muscles to look FULL AS F*CK.\r\n\r\nYet there’s more than just a visual benefit to getting a great pump. That’s because the increased blood flow carries critical oxygen and nutrients to your working muscles. This improves endurance so you can get your best workout every time.\r\n\r\nOf course, most bodybuilders want the most extreme pump they can get. They’ll search the market for the best pump-enhancing supplement they can find. If you're looking for the ultimate pump, FULL AS F*CK is your desired pump pre-workout.	https://5percentnutrition.com/products/faf-nitric-oxide-booster	https://5percentnutrition.com/cdn/shop/products/full-as-f-ck-nitric-oxide-booster-legendary-series-5percent-nutrition-1.png?v=1746114679&width=1400	48.99	14	30	350	t	full-as-f-ck	\N	23	2025-05-14 16:31:00	2025-05-14 16:31:20
43	Kill-It	It's been a popular and established part of our pre-workout lineup for quite some time - until we decided to shake things up. Now, it’s more hardcore than ever!\r\n\r\nOne of the great things about Kill It Pre-Workout is its flexibility. It’s always been and continues to be the perfect first pre-workout at one scoop. At this serving size, it's also the answer for lifters who prefer less caffeine. When you bump that up to two scoops per serving, we're looking at a more hardcore pre-workout!\r\n\r\nLook at the formula. Kill It Pre-Workout still stands apart as one of the few pre-workouts containing creatine monohydrate. Now, there’s 325 mg of caffeine (with the 2-scoop serving). This outstanding pre-workout features an advanced combination of energy, pump, focus, endurance, and performance ingredients. Of course, they are precisely formulated to create a complete, balanced pre-workout. Many pre-workouts target either the pump or energy. Kill It Pre-Workout gives lifters a fully disclosed formula with flexible serving sizes. Finally, it tastes incredible, with two new flavors added to the lineup!	https://5percentnutrition.com/products/kill-it-pre-workout	https://5percentnutrition.com/cdn/shop/files/KillIt_BlueberryLemonade_WEB.png?v=1740000174&width=1400	39.99	20.4	20	404	t	kill-it	\N	23	2025-05-14 17:01:33	2025-05-14 17:01:33
57	Defcon1	DEFCON1, for when the shit's about to hit the fan kind of workout! This explosive high-stim pre-workout targets epic strength & power, intense energy, & peak performance.	https://anabolicwarfare.defynedbrands.com/products/defcon1	https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWDEFCON1BBL_200.003.01_v2.3_Render.png?v=1743516713&width=1800&crop=center	59.99	31	20	620	t	defcon1	\N	11	2025-05-18 02:09:53	2025-05-18 02:09:53
61	BlackMarket x Anabolic Warfare SCORCH	Introducing SCORCH - an explosive collaboration between Anabolic Warfare & BlackMarketLabs\r\n\r\nScorch is the pinnacle of ultra-thermogenic pre-workouts. Loaded with a potent, fat-shredding formula that ramps up your metabolism to torch fat, crafted to ignite your performance, & amplify your endurance through your most intense workouts.	https://anabolicwarfare.defynedbrands.com/products/blackmarket-x-anabolic-warfare-scorch	https://cdn.shopify.com/s/files/1/0068/1925/0235/files/Scorch-CherryBomb-FRONT.png?v=1747159135&width=1800&crop=center	54.99	19.1	20	384	t	blackmarket-x-anabolic-warfare-scorch	\N	11	2025-05-18 02:25:17	2025-05-18 02:25:17
69	ABE	ABE™ Ultimate Pre-Workout delivers a unique blend of the most vital and researched active ingredients known to help increase physical performance†, reduce tiredness & fatigue†, and provide continual focus throughout your training, maximizing your body's potential. However, talk is cheap and the proof is in the product. After extensive research, meticulous formulating, and precise lab testing, we are confident to let ABE™ do the talking. \r\n\r\nWe believe true excellence comes from within. That’s why every ingredient in the ABE™ pre workout formula is subject to extensive research and lab testing. We go to great lengths to ensure you are only putting the best in your body. Using reputable 3rd party Informed Choice Supplement testing, we make sure our pre-workout is accredited, free of banned substances, and perfected for use by professional athletes.	\N	\N	44.99	13	30	390	t	abe	\N	7	2025-05-24 19:47:45	2025-05-24 19:47:45
70	Hooligan Extreme	\N	https://www.apollonnutrition.com/products/hooligan-newest-version	https://www.apollonnutrition.com/cdn/shop/files/hooligan-extreme-pre-workout-apollon-nutrition-609062.jpg?v=1732324961&width=1946	59.95	20.65	40	800	t	hooligan-extreme	\N	48	2025-05-24 19:54:55	2025-05-24 19:54:55
71	Desperado	It stands to reason that you’d have a pre workout that you can rely on for a great workout, every workout. Now, don’t confuse cost-effective go-to pre workouts with the cracked-out stim bombs you chug after a night of 4 hours of sleep and a raging hangover (these pre workouts also have their place, but hopefully they’re used sparingly).\r\n\r\nNo, a cost effective go-to pre workout is the one that day in, day out, you mix up, drink, and BAM! You’re ready to seize the day.\r\n\r\nDesperado is the cost-effective pre workout Apollon style.\r\n\r\nTrue to Apollon form, we’ve packed out the performance and focus but keep the energy “moderate” (at least by our standards, which is to say it’s “high” for 90% of other brands).\r\n\r\nWith Desperado, you get it ALL -- energy, performance, pumps, and focus -- while being a cost-effective solution to fuel your daily training!	https://www.apollonnutrition.com/products/desperado-pre-workout	https://www.apollonnutrition.com/cdn/shop/files/desperado-pre-workout-apollon-nutrition-704587.jpg?v=1732324961&width=1946	44.95	11.4	40	454	t	desperado	\N	48	2025-05-24 20:03:15	2025-05-24 20:03:15
44	Reloaded	Introducing Reloaded, the next evolution in 5% Nutrition pre-workouts. A popular member of our lineup, Reloaded has now been enhanced to be more hardcore than ever, setting it apart from the rest.\r\n\r\nReloaded offers a unique flexibility with its 1 or 2 scoop servings. At one scoop, it's a great choice for those who prefer a little less Caffeine. But at two scoops, it transforms into one of the most hardcore pre-workouts available, catering to a wide range of fitness needs.\r\n\r\nCheck out the formula - Reloaded is a pre-workout that stands above the crowd with an exceptional list of ingredients. 5% Nutrition has always been one of the few companies that feature Creatine Monohydrate in our pre-workouts. Now, we've gone a step further and created an exclusive Creatine Blend that features Creatine Monohydrate and 2 other forms of Creatine. What about Caffeine? We thought you'd never ask! Now, there are 3 sources supplying 360 mg of Caffeine (at two scoops). And there's also a whopping 8 grams (at 2 scoops) of pure L-Citrulline - the most we've ever put in a pre-workout. Reloaded is an outstanding pre-workout featuring an advanced combination of energy, pump, focus, endurance, and performance ingredients. Of course, every ingredient with its dosage is clearly listed on the label - there are no prop blends here! The ingredient profile is designed to create a complete, balanced pre-workout. Reloaded has it all, and of course, it tastes incredible, making it a treat for your taste buds!	https://5percentnutrition.com/products/reloaded-pre-workout	https://5percentnutrition.com/cdn/shop/files/Reloaded_Frostbite_WEB.png?v=1746115431&width=1400	52.99	27.4	20	548	t	reloaded	\N	23	2025-05-14 17:06:21	2025-05-14 17:06:21
45	Creatine Pre-Workout	Get the edge in every workout with our Advanced Pre-Workout Formula, a powerhouse blend designed to boost energy, focus, and performance. Packed with creatine monohydrate, natural caffeine, and a unique blend of adaptogens, this formula is perfect for anyone looking to take their workouts to the next level. Whether you're hitting the gym or gearing up for a big game, this formula provides the support you need to push through your toughest sessions.	https://ainutrition.com/products/creatine	https://ainutrition.com/cdn/shop/files/AIN_Energy_Watermelon_Angled_Shadow_1920x.png?v=1710973916	39.00	5	40	200	t	creatine-pre-workout	\N	8	2025-05-14 22:11:33	2025-05-14 22:11:33
46	Bangalore	When you step into the gym, you don’t need a sugar rush or a temporary high — you need real performance.\r\n\r\nBangalore Pre-Workout is built for athletes who demand more from themselves and their supplements.\r\n\r\nThis isn't just about getting hyped — it’s about dialing into the zone where strength, endurance, and focus collide.\r\n\r\nWith a clean, powerful blend of energy drivers, blood flow enhancers, focus agents, and hydration support, Bangalore unlocks your body's true capacity without the crash, jitters, or burnout of cheap pre-workouts.\r\n\r\nWhether you're crushing a heavy lift, grinding through a brutal endurance session, or chasing the best version of yourself — Bangalore keeps you locked in from the first rep to the final sprint.\r\n\r\nIf you're ready for serious training, you’re ready for Bangalore.	https://thealphacountry.com/collections/pre-workout/products/bangalore-pre-workout	https://thealphacountry.com/cdn/shop/files/55BlackBangaloreMangofront.png?v=1721305938	44.99	22.23	30	644	t	bangalore	\N	63	2025-05-14 22:17:21	2025-05-14 22:17:21
47	Pump Non-Stim	You don’t need stimulants to have a powerful session — you need real blood flow, deep muscle hydration, and clean recovery support.\r\n\r\nPump – Non-Stim Pre-Workout is built for lifters and athletes who want all the performance benefits without relying on caffeine or crash-heavy energy.\r\n\r\nWith a powerhouse blend of ingredients that drive nitric oxide production, optimize hydration, and support recovery, Pump helps you train harder, look fuller, and recover faster — all without the stimulant overload.\r\n\r\nFeel the pump, see the difference, and dominate your training — day or night.	https://thealphacountry.com/collections/pre-workout/products/pump-non-stim	https://thealphacountry.com/cdn/shop/files/IMG_7825.png?v=1724988826&width=1080	44.99	15.5	30	465	t	pump-non-stim	\N	63	2025-05-14 22:20:57	2025-05-14 22:20:57
55	Stim Lord	Unleash your inner Escobar and dominate your workout with Stim Lord. Our potent pre-workout blend is stacked with muscle pump activators and loaded up with caffeine to dominate your workouts.	https://anabolicwarfare.defynedbrands.com/products/stim-lord	https://cdn.shopify.com/s/files/1/0068/1925/0235/files/AWSTIMLORDBRC_190.009.01_v1.3_Render.png?v=1743516697&width=1800&crop=center	56.99	21.8	20	436	t	stim-lord	\N	11	2025-05-18 01:51:03	2025-05-18 01:51:03
50	Superhuman Burn	A 2-in-1 fat burning pre-workout (21 servings) designed to amplify your caloric expenditure while increasing training intensity.† Featuring research backed ingredients and powered by our novel SXT™ Energy System, Superhuman Burn will help you burn more calories while elevating strength and focus.† Truly the best of both worlds.	https://www.alphalion.com/products/superhuman-burn-pre-workout-fat-burner	https://www.alphalion.com/cdn/shop/products/SH-BURN-HULK-JUICE_1_1.png?v=1706628381	59.99	14.9	21	310	t	superhuman-burn	\N	4	2025-05-18 00:15:36	2025-05-18 00:15:36
51	Superhuman Pre	The original, high-performance pre-workout (21 Servings) that is the gold standard of training intensity. Its jam-packed but well-rounded formula is the perfect solution for anyone struggling with gym motivation or stagnant workouts.	https://www.alphalion.com/products/superhuman-pre-workout	https://www.alphalion.com/cdn/shop/products/SH-PRE-HULK-JUICE_1_1.png?v=1744740350	49.99	16.4	21	342	t	superhuman-pre	\N	4	2025-05-18 00:18:48	2025-05-18 00:18:48
52	Superhuman Extreme	Ready to take your workout intensity to the extreme? Behold our fully loaded pre-workout formula that takes feeling Superhuman to the next level (21 servings). \r\n\r\nWith 350 mg of SXT™ energy + more hard-hitting ingredients than our original Superhuman Pre, Superhuman Extreme is perfect for anyone who craves extreme athletic performance.	https://www.alphalion.com/products/superhuman-extreme	https://www.alphalion.com/cdn/shop/files/SHEXTREMEHULKJUICEFRONT1500X1500.png?v=1744740374	49.99	16.1	21	325	t	superhuman-extreme	\N	4	2025-05-18 00:21:56	2025-05-18 00:21:56
53	Superhuman Pump	Crave Superhuman performance without caffeine? Try this stimulant-free pump and performance pre-workout (42 servings) designed to maximize vascularity, strength and power output.†\r\n\r\nPerfect for anyone sensitive to stimulants, night owl athletes, or anyone cycling off caffeine.	https://www.alphalion.com/products/superhuman-pump	https://www.alphalion.com/cdn/shop/products/SuperhumanPumpHulkJuice_48f0db29-c501-465b-9c64-18bb709fd0fe.png?v=1744740366	49.99	18	21	372	t	superhuman-pump	\N	4	2025-05-18 00:24:13	2025-05-18 00:24:13
54	Superhuman Core	Craving Superhuman performance without all the bells and whistles? Superhuman Core (30 servings) is your essential budget-friendly pre-workout that’s perfect for beginners or advanced athletes.\r\n\r\nPowered by the 6 most synergistic ingredients -- including creatine -- for peak Superhuman training. Long-lasting energy, focus, and intensity without the price tag.	https://www.alphalion.com/products/superhuman-core	https://www.alphalion.com/cdn/shop/files/SH_CPW_RAZZLEMANIA_3.png?v=1746469665	29.99	10	30	301	t	superhuman-core	\N	4	2025-05-18 00:26:36	2025-05-18 00:26:36
64	Animal Primal	Ready to work harder than ever? Ready for a pre-workout that doesn’t pull any punches? Then you’re ready for Primal. An innovative, science-backed pre-workout loaded with over 20 proven and patented ingredients that give your body and mind everything they need to blow the limits off your limits.\r\n\r\nGET MAX ENERGY thanks to caffeine anhydrous (300mg), green tea leaf extract, and guarana seed that combine to deliver a more relentless energy jolt without the uncomfortable jitters or crashes.\r\n\r\nGET MAX FOCUS with a powerful combination of TeaCrine® (50mg) and L-tyrosine (1000mg) that locks you into peak mental performance so you can fixate on every rep and dig deeper to destroy more sets.\r\n\r\nGET MAX ENDURANCE from beta-alanine (3200mg) and taurine (1000mg) that get you more amped–and keep you more amped–by reducing lactic acid buildup and increasing muscle stamina.\r\n\r\nGET MAX HYDRATION with a unique electrolyte complex, as well as 25mg of Astragin® and 25mg of Senactiv® to help you wage war on sweat by absorbing more nutrients and recovering faster.\r\n\r\nGET MAX PUMP with 6000mg of 3DPUMP-Breakthrough® that contains L-Citrulline, high-yield glycerol, and Amla fruit extract for those legendary skin-splitting results.\r\n\r\nGET MAX FLAVOR with easy mixing and no chalky aftertaste. Available in three uniquely craveable new varieties: Dragon Berry, Wick’d Peach, and Candy Crush’d.\r\n\r\nPrimal Pre-Workout is GMP-certified and third-party lab testing for quality, safety, and potency.\r\n\r\nExplosive Energy, Mental Focus, Muscle Pump, and Stamina\r\nPatented Ingredients for Intense Workouts–Train Longer and Harder\r\nGreat Taste, Easy to Mix, and Two Delicious Fruit Flavors	https://www.animalpak.com/products/primal-preworkout-powder-supplement	https://www.animalpak.com/cdn/shop/files/Primal_BloodOrange_stamp_1080x1080_ff43283f-fab2-4cca-94dd-c3e2ca7ede6f.jpg?v=1747808386&width=800	45.95	40.2	25	502	t	animal-primal	\N	1	2025-05-24 18:51:36	2025-05-24 18:51:36
65	Animal Pump Non-Stim	Maximize your muscle pump and vascularity with our pre-workout formula that is the ultimate choice for gym-goers seeking quick and sustained pumps, performance & endurance, and focus without stimulants.\r\n\r\nFeaturing clinical doses of L-Citrulline and Nitrosigine®, the Pump & Performance Complex boosts blood flow, muscle fullness, vascularity and nutrient delivery\r\nBeta Alanine, Betaine Anhydrous and L-Taurine enhance strength, endurance, and workout performance.\r\nThe combined mix of Nitrosigine and Tyrosine helps provide laser focus during the workout without the need for stims like caffeine.\r\nThe Electrolytes & Hydration Complex provides key electrolytes to support hydration during intense workouts.\r\nThe “pump” is perhaps the most important physiological process when it comes to muscle-building. It is also how oxygen and nutrient-rich blood engorges working muscle, feeding it so that it can grow. Not only does it make you look bigger, blowing up the target muscle group like a balloon, it actually makes you bigger by triggering the process of anabolism. This process of muscle volumization is critical to muscle growth.\r\nWith Animal Pump Non-Stim, we designed a formula specifically to “up the volume” while improving performance through five key complexes:\r\n\r\nStimulant-Free Formula: Perfect for evening workouts or for those who prefer caffeine-free performance.\r\nMuscle Fullness + Quick-Acting & Long-Lasting Pumps: Includes 6g of L-Citrulline and 1.5g of Nitrosigine® for increased nitric oxide production, enhanced vascularity, and nutrient delivery. Nitrosigine® is clinically proven to deliver intense pumps and performance in just 15 minutes with effects lasting up to 6 hours.\r\nPerformance and Endurance: with 3.2g Beta Alanine, 2.5g Betaine to enhance strength, endurance and overall workout performance.\r\nImproved Mental Clarity & Focus: with 2g of Tyrosine and 1.5g Nitrosigine to support mental clarity, focus, and workout intensity without stimulants.\r\nOptimized Hydration Support: Infused with essential electrolytes to maintain hydration, electrolyte balance and muscle fullness during intense workouts.\r\nBigger pumps lead to muscle growth, it’s as simple as that.	https://www.animalpak.com/products/animal-pump-non-stim	https://www.animalpak.com/cdn/shop/files/PumpNS_DragonBerry_PDP_1080x1080_7aa030ae-d61e-46c1-aafb-caa90267b36c.jpg?v=1744038416&width=800	49.95	11	40	440	t	animal-pump-non-stim	\N	1	2025-05-24 18:55:43	2025-05-24 18:55:43
66	Animal Fury	A no-nonsense yet powerful pre-workout supplement, Animal Fury is formulated with 350mg of Caffeine Anhydrous plus Citrulline Malate for increased nitrous oxide, Beta Alanine, L-Tyrosine, and BCAAs in each scoop. Train harder than you thought possible with high powered and great tasting Animal Fury, designed for both men and women.\r\n\r\n350mg caffeine and 5g BCAA per serving\r\nEnhances energy, performance, focus, and recovery\r\nFeel the kick without bloating or upset stomach\r\nAnimal Fury pre-workout powder helps you stay focused and energized no matter what type of training you do, with vein popping pumps, nitric oxide, high energy and focus every single workout. Combining proven pre-training staples like Citrulline Malate, Beta Alanine, L-Tyrosine and Caffeine Anhydrous, formulated in the right doses, plus five grams of Branched-Chain Amino Acids (BCAA) in every scoop, Animal Fury packs a muscle-building punch. Additionally, this creatine free formula is perfect for any athlete in a bulk or cut season.\r\n\r\nComing in crisp and refreshing Green Apple, Blue Raspberry, Ice Pop, and Watermelon flavors, Animal Fury also features a tantalizing taste. This great-tasting pre-workout powder mixes easily in 12oz. of water or your drink of choice, and packs a powerful and delicious taste for all athletes. Flavorful and bright, drinking Animal Fury is an enjoyable ritual you will look forward to with each delicious sip giving you more energy and sharper focus.	https://www.animalpak.com/products/animal-fury-pre-workout-powder-supplement	https://www.animalpak.com/cdn/shop/files/Fury_KiwiLime_2000x2000_13728efa-575b-4390-af8d-c53a6e08261d.jpg?v=1746597407&width=800	35.95	17	30	510	t	animal-fury	\N	1	2025-05-24 18:57:52	2025-05-24 18:57:52
67	AN Performance Pre	Life is a series of moments, and athletic life is no different. You train day in and day out, preparing for that critical situation when it's your time to shine. Whether it's chasing a personal record in the squat rack, delivering a clutch performance in the bottom of the 9th, or pushing through exhaustion in overtime, you need to be at your best when it counts. That's why we developed the AN Performance Pre-Workout – to fuel your moment. Put simply, we've built a pre-workout formula that not only performs better, it feels better. The AN Performance Pre-Workout combines scientifically-backed ergogenic ingredients, cutting-edge focus enhancers, and unique mood-boosters to ensure you perform at your peak for every moment. With 6g of L-Citrulline, 3.2g of Beta-Alanine, and 2.5 grams of Betaine, we provide the essential support for endurance and power, taking you from sideline to sideline until the whistle blows. Additionally, we've included 300mg of naturally-sourced PurCaf caffeine to deliver a clean, sustained energy boost, keeping you energized and alert throughout your workout. But that's just the beginning. These are the bare minimums for a top-tier pre-workout in today's competitive landscape. The real experience begins in our mental focus blend, where we've curated a clinically-researched 500mg of Cognizin Citicoline alongside 2g of Tyrosine to sharpen your mental focus. Additionally, 2g of Taurine, and 100mg of NeuroRush Coffee Fruit Extract provide unique, feel-good benefits that enhance your overall workout experience and keep you in the zone -- without overstimulating you. Balanced with 150mg of salt and 300mg of potassium citrate, this pre-workout also supports hydration and electrolyte levels to keep you going from start to finish. Engineered for serious athletes who demand the best and are here to win, AN Performance Pre-Workout is your key to unlocking peak performance. Fuel your moment and own it with a formula dedicated to excellence, just like you.	https://ansupps.com/collections/pre-workout/products/an-performance-pre-workout	https://ansupps.com/cdn/shop/files/AN-Performance-PRE-390g-BR-Front.png?v=1732587969&width=1200	49.99	13	30	390	t	an-performance-pre	\N	7	2025-05-24 19:42:10	2025-05-24 19:42:10
68	AN Performance Zero-Caffeine Pre	Who says "stimulant-free" should mean "zero-energy"?! At AN Performance, we're redefining the game with our Non-Stim Pre-Workout formula, here to impact your every moment, regardless of the time. It's based upon our caffeinated pre-workout, but with an added twist. The AN Non-Stim Pre-Workout starts with the classic blend of 6g of L-Citrulline, 3.2g of Beta-Alanine, 2.5 grams of Betaine, 2 grams of taurine, and electrolytes from sodium and potassium. This powerful combination supports blood flow, power output, and fluid balance, ensuring you're primed for peak performance. But where we shift gears is by including Peak ATP - literal cellular energy in the form of disodium ATP -when dropping the 300mg caffeine from PurCaf. Peak ATP goes beyond simple energy, supporting improved blood flow, peak power, total strength, and lean body mass. Paired with the highly-experiential trifecta of L-Tyrosine (2g), Cognizin Citicoline (500mg), NeuroRush coffee fruit extract (100mg), you'll be fully present in the moment… so that you can seize the moment. With a formula like this, you no longer need tons of caffeine to feel energy. Athletic supplement users want experiential products they can feel, a challenge in the lower-stimulant space. But it's a challenge we've overcome, because the AN Performance Zero-Caffeine Pre-Workout can be felt -and it's here to fuel your moment, day or night.	https://ansupps.com/collections/pre-workout/products/anp-zero-caffeine-pre-workout	https://ansupps.com/cdn/shop/files/AN-Performance-ZC-PRE-390g-BR-Front.png?v=1732588877&width=1200	49.99	13	30	390	t	an-performance-zero-caffeine-pre	\N	7	2025-05-24 19:44:48	2025-05-24 19:44:48
72	Bare Knuckle	\N	https://www.apollonnutrition.com/products/hooligan-bare-knuckle-premium-non-stimulant-pre-workout-powerhouse	https://www.apollonnutrition.com/cdn/shop/files/bare-knuckle-premium-non-stimulant-nitrate-infused-pre-workout-powerhouse-apollon-nutrition-510712.jpg?v=1732324950&width=1946	59.95	14	40	540	t	bare-knuckle	\N	48	2025-05-24 20:09:32	2025-05-24 20:09:32
73	Bloodsport	\N	https://www.apollonnutrition.com/products/bareknuckle-bloodsport-extreme-blood-pumping-powder-with-nitrates	https://www.apollonnutrition.com/cdn/shop/files/bloodsport-extreme-blood-pumping-powder-with-nitrates-apollon-nutrition-114003.jpg?v=1732324947&width=1946	59.95	8.5	40	300	t	bloodsport	\N	48	2025-05-24 20:11:32	2025-05-24 20:11:32
74	PRE99	\N	https://www.apollonnutrition.com/products/pre99-strawberry-banana-99-servings	https://www.apollonnutrition.com/cdn/shop/files/pre99-strawberry-banana-99-servings-apollon-nutrition-577068.png?v=1743603605&width=1946	139.00	29.5	99	2920	t	pre99	\N	48	2025-05-24 20:14:33	2025-05-24 20:14:33
75	Apollon Gym Classic	Apollon Gym Classic offers an affordable solution that doesn’t compromise on quality or effectiveness. \r\n\r\nWe’ve included only the most well-studied and evidence-based pre workout supplements and packaged them together in one affordable, delicious, and effective budget pre workout.	https://www.apollonnutrition.com/products/apollon-gym-classic	https://www.apollonnutrition.com/cdn/shop/files/apollon-gym-classic-apollon-nutrition-227096.png?v=1736965337&width=1946	29.95	15.4	30	462	t	apollon-gym-classic	\N	48	2025-05-24 20:16:42	2025-05-24 20:16:42
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schema_migrations (version, inserted_at) FROM stdin;
20250430005447	2025-04-30 00:55:16
20250430224017	2025-04-30 22:48:32
20250430224035	2025-04-30 22:48:33
20250430224049	2025-04-30 22:48:34
20250430224104	2025-04-30 22:48:35
20250503202618	2025-05-03 20:28:51
20250503203004	2025-05-03 20:30:26
20250508222432	2025-05-08 22:25:14
20250511014526	2025-05-11 01:45:53
20250511022453	2025-05-11 02:25:06
20250511211558	2025-05-11 21:16:19
20250511211852	2025-05-11 21:19:06
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, hashed_password, confirmed_at, inserted_at, updated_at) FROM stdin;
1	alex@alexezell.com	\N	2025-04-30 00:57:11	2025-04-30 00:56:46	2025-04-30 00:57:11
\.


--
-- Data for Name: users_tokens; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users_tokens (id, user_id, token, context, sent_to, authenticated_at, inserted_at) FROM stdin;
2	1	\\x1da8fd32ce1168f3a94610b33fe5f14589593baf3991188c446e369d4c8ca869	session	\N	2025-04-30 00:57:11	2025-04-30 00:57:11
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2025-04-26 22:32:56
20211116045059	2025-04-26 22:32:59
20211116050929	2025-04-26 22:33:01
20211116051442	2025-04-26 22:33:03
20211116212300	2025-04-26 22:33:06
20211116213355	2025-04-26 22:33:08
20211116213934	2025-04-26 22:33:10
20211116214523	2025-04-26 22:33:13
20211122062447	2025-04-26 22:33:15
20211124070109	2025-04-26 22:33:17
20211202204204	2025-04-26 22:33:19
20211202204605	2025-04-26 22:33:21
20211210212804	2025-04-26 22:33:27
20211228014915	2025-04-26 22:33:29
20220107221237	2025-04-26 22:33:31
20220228202821	2025-04-26 22:33:33
20220312004840	2025-04-26 22:33:35
20220603231003	2025-04-26 22:33:38
20220603232444	2025-04-26 22:33:40
20220615214548	2025-04-26 22:33:43
20220712093339	2025-04-26 22:33:45
20220908172859	2025-04-26 22:33:47
20220916233421	2025-04-26 22:33:49
20230119133233	2025-04-26 22:33:51
20230128025114	2025-04-26 22:33:54
20230128025212	2025-04-26 22:33:56
20230227211149	2025-04-26 22:33:58
20230228184745	2025-04-26 22:34:00
20230308225145	2025-04-26 22:34:02
20230328144023	2025-04-26 22:34:04
20231018144023	2025-04-26 22:34:06
20231204144023	2025-04-26 22:34:09
20231204144024	2025-04-26 22:34:11
20231204144025	2025-04-26 22:34:14
20240108234812	2025-04-26 22:34:16
20240109165339	2025-04-26 22:34:18
20240227174441	2025-04-26 22:34:21
20240311171622	2025-04-26 22:34:24
20240321100241	2025-04-26 22:34:28
20240401105812	2025-04-26 22:34:34
20240418121054	2025-04-26 22:34:37
20240523004032	2025-04-26 22:34:44
20240618124746	2025-04-26 22:34:46
20240801235015	2025-04-26 22:34:48
20240805133720	2025-04-26 22:34:50
20240827160934	2025-04-26 22:34:52
20240919163303	2025-04-26 22:34:55
20240919163305	2025-04-26 22:34:57
20241019105805	2025-04-26 22:34:59
20241030150047	2025-04-26 22:35:07
20241108114728	2025-04-26 22:35:10
20241121104152	2025-04-26 22:35:12
20241130184212	2025-04-26 22:35:14
20241220035512	2025-04-26 22:35:16
20241220123912	2025-04-26 22:35:18
20241224161212	2025-04-26 22:35:20
20250107150512	2025-04-26 22:35:22
20250110162412	2025-04-26 22:35:24
20250123174212	2025-04-26 22:35:26
20250128220012	2025-04-26 22:35:28
20250506224012	2025-05-26 19:48:14
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2025-04-26 22:32:53.837743
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2025-04-26 22:32:53.843244
2	storage-schema	5c7968fd083fcea04050c1b7f6253c9771b99011	2025-04-26 22:32:53.846946
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2025-04-26 22:32:53.865694
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2025-04-26 22:32:53.891638
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2025-04-26 22:32:53.895624
6	change-column-name-in-get-size	f93f62afdf6613ee5e7e815b30d02dc990201044	2025-04-26 22:32:53.900068
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2025-04-26 22:32:53.904479
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2025-04-26 22:32:53.910253
9	fix-search-function	3a0af29f42e35a4d101c259ed955b67e1bee6825	2025-04-26 22:32:53.91506
10	search-files-search-function	68dc14822daad0ffac3746a502234f486182ef6e	2025-04-26 22:32:53.923671
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2025-04-26 22:32:53.928208
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2025-04-26 22:32:53.936077
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2025-04-26 22:32:53.940395
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2025-04-26 22:32:53.945442
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2025-04-26 22:32:53.971967
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2025-04-26 22:32:53.976334
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2025-04-26 22:32:53.980726
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2025-04-26 22:32:53.985761
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2025-04-26 22:32:53.993431
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2025-04-26 22:32:53.998016
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2025-04-26 22:32:54.008513
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2025-04-26 22:32:54.038287
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2025-04-26 22:32:54.064803
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2025-04-26 22:32:54.069235
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2025-04-26 22:32:54.073312
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.schema_migrations (version, statements, name) FROM stdin;
\.


--
-- Data for Name: seed_files; Type: TABLE DATA; Schema: supabase_migrations; Owner: -
--

COPY supabase_migrations.seed_files (path, hash) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 1, false);


--
-- Name: brands_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.brands_id_seq', 137, true);


--
-- Name: ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ingredients_id_seq', 312, true);


--
-- Name: product_ingredients_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.product_ingredients_id_seq', 449, true);


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.products_id_seq', 75, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: users_tokens_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_tokens_id_seq', 3, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: ingredients ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ingredients
    ADD CONSTRAINT ingredients_pkey PRIMARY KEY (id);


--
-- Name: product_ingredients product_ingredients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_pkey PRIMARY KEY (id);


--
-- Name: products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_tokens users_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: seed_files seed_files_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: -
--

ALTER TABLE ONLY supabase_migrations.seed_files
    ADD CONSTRAINT seed_files_pkey PRIMARY KEY (path);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: brands_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX brands_name_index ON public.brands USING btree (name);


--
-- Name: brands_slug_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX brands_slug_index ON public.brands USING btree (slug);


--
-- Name: ingredients_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ingredients_name_index ON public.ingredients USING btree (name);


--
-- Name: ingredients_slug_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX ingredients_slug_index ON public.ingredients USING btree (slug);


--
-- Name: product_ingredient_unique_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX product_ingredient_unique_index ON public.product_ingredients USING btree (product_id, ingredient_id);


--
-- Name: product_ingredients_ingredient_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_ingredients_ingredient_id_index ON public.product_ingredients USING btree (ingredient_id);


--
-- Name: product_ingredients_product_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX product_ingredients_product_id_index ON public.product_ingredients USING btree (product_id);


--
-- Name: products_brand_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX products_brand_id_index ON public.products USING btree (brand_id);


--
-- Name: products_name_brand_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_name_brand_id_index ON public.products USING btree (name, brand_id);


--
-- Name: products_slug_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX products_slug_index ON public.products USING btree (slug);


--
-- Name: users_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_index ON public.users USING btree (email);


--
-- Name: users_tokens_context_token_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_tokens_context_token_index ON public.users_tokens USING btree (context, token);


--
-- Name: users_tokens_user_id_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX users_tokens_user_id_index ON public.users_tokens USING btree (user_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: product_ingredients product_ingredients_ingredient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_ingredient_id_fkey FOREIGN KEY (ingredient_id) REFERENCES public.ingredients(id) ON DELETE RESTRICT;


--
-- Name: product_ingredients product_ingredients_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.product_ingredients
    ADD CONSTRAINT product_ingredients_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.products(id) ON DELETE CASCADE;


--
-- Name: products products_brand_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_brand_id_fkey FOREIGN KEY (brand_id) REFERENCES public.brands(id) ON DELETE RESTRICT;


--
-- Name: users_tokens users_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_tokens
    ADD CONSTRAINT users_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

