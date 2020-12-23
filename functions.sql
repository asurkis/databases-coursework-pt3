CREATE OR REPLACE FUNCTION add_human(
    arg_name TEXT,
    arg_info TEXT,
    arg_phone TEXT = NULL,
    arg_email TEXT = NULL,
    arg_telegram TEXT = NULL,
    arg_vk TEXT = NULL) RETURNS INT
AS $$
    INSERT INTO human (name, phone, email, telegram, vk, info) VALUES
        (arg_name, arg_phone, arg_email, arg_telegram, arg_vk, arg_info)
        RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION add_player(
    arg_name TEXT,
    arg_info TEXT,
    arg_phone TEXT = NULL,
    arg_email TEXT = NULL,
    arg_telegram TEXT = NULL,
    arg_vk TEXT = NULL) RETURNS INT AS $$
DECLARE inserted INT;
BEGIN
    SELECT add_human(arg_name, arg_phone, arg_email, arg_telegram, arg_vk, arg_info) INTO inserted;
    INSERT INTO player (human) SELECT RETURNING human;
    RETURN inserted;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_artist(
    arg_name TEXT,
    arg_info TEXT,
    arg_phone TEXT = NULL,
    arg_email TEXT = NULL,
    arg_telegram TEXT = NULL,
    arg_vk TEXT = NULL) RETURNS INT AS $$
DECLARE inserted INT;
BEGIN
    SELECT add_human(arg_name, arg_phone, arg_email, arg_telegram, arg_vk, arg_info) INTO inserted;
    INSERT INTO artist (human) SELECT RETURNING human;
    RETURN inserted;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_organizer(
    arg_name TEXT,
    arg_info TEXT,
    arg_phone TEXT = NULL,
    arg_email TEXT = NULL,
    arg_telegram TEXT = NULL,
    arg_vk TEXT = NULL) RETURNS INT AS $$
DECLARE inserted INT;
BEGIN
    SELECT add_human(arg_name, arg_phone, arg_email, arg_telegram, arg_vk, arg_info) INTO inserted;
    INSERT INTO organizer (human) SELECT RETURNING human;
    RETURN inserted;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_sponsor(
    arg_name TEXT,
    arg_info TEXT,
    arg_phone TEXT = NULL,
    arg_email TEXT = NULL,
    arg_telegram TEXT = NULL,
    arg_vk TEXT = NULL) RETURNS INT AS $$
DECLARE inserted INT;
BEGIN
    SELECT add_human(arg_name, arg_phone, arg_email, arg_telegram, arg_vk, arg_info) INTO inserted;
    INSERT INTO sponsor (human) SELECT RETURNING human;
    RETURN inserted;
END; $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_sponsor_contract(
    arg_sponsor INTEGER,
    arg_organizer INTEGER,
    arg_info TEXT) RETURNS INT
AS $$
    INSERT INTO sponsor_contract (sponsor, organizer, info) VALUES
        (arg_sponsor, arg_organizer, arg_info)
        RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION add_rule_set(arg_name TEXT) RETURNS INT
AS $$
    INSERT INTO rule_set (name) VALUES (arg_name) RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION add_character_stat_type(
    arg_rule_set INTEGER,
    arg_name TEXT,
    arg_description TEXT,
    arg_default_value INTEGER = NULL) RETURNS INT
AS $$
    INSERT INTO character_stat_type(rule_set, name, description, default_value) VALUES
        (arg_rule_set, arg_name, arg_description, arg_default_value)
        RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION add_rule(
    arg_rule_set INTEGER,
    arg_condition TEXT,
    arg_stat_to_modify INTEGER,
    arg_action_with_stat TEXT,
    arg_value_of_modification INTEGER) RETURNS INT
AS $$
    INSERT INTO rule(
            rule_set,
            condition,
            stat_to_modify,
            action_with_stat,
            value_of_modification)
        VALUES (
            arg_rule_set,
            arg_condition,
            arg_stat_to_modify,
            arg_action_with_stat,
            arg_value_of_modification)
        RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION add_character(
    arg_name TEXT,
    arg_rule_set INTEGER,
    arg_player INTEGER) RETURNS INT
AS $$
    INSERT INTO character (name, rule_set, player) VALUES
        (arg_name, arg_rule_set, arg_player)
        RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION add_tournament(
    arg_place TEXT,
    arg_start_date TIMESTAMPTZ,
    arg_finish_date TIMESTAMPTZ,
    arg_organizer INTEGER,
    arg_rule_set INTEGER) RETURNS INT
AS $$
    INSERT INTO tournament (place, start_date, finish_date, organizer, rule_set) VALUES
        (arg_place, arg_start_date, arg_finish_date, arg_organizer, arg_rule_set)
        RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE PROCEDURE add_performance(
    arg_artist INTEGER,
    arg_tournament INTEGER)
AS $$
    INSERT INTO performance (artist, tournament) VALUES
        (arg_artist, arg_tournament);
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION add_game(arg_tournament INTEGER) RETURNS INT
AS $$
    INSERT INTO game (tournament) VALUES (arg_tournament) RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION add_game_event(
    arg_game INTEGER,
    arg_agent INTEGER,
    arg_object INTEGER,
    arg_description TEXT,
    arg_time TIMESTAMPTZ,
    arg_rule_applied INTEGER) RETURNS INT
AS $$
    INSERT INTO game_event (
            game,
            agent,
            object,
            description,
            time,
            rule_applied
        ) VALUES (
            arg_game,
            arg_agent,
            arg_object,
            arg_description,
            arg_time,
            arg_rule_applied
        ) RETURNING id;
$$ LANGUAGE sql;

CREATE OR REPLACE PROCEDURE add_tournament_result(
    arg_tournament INTEGER,
    arg_player INTEGER,
    arg_score INTEGER = NULL,
    arg_place INTEGER = NULL)
AS $$
    INSERT INTO tournament_result (tournament, player, score, place) VALUES
        (arg_tournament, arg_player, arg_score, arg_place);
$$ LANGUAGE sql;

CREATE OR REPLACE PROCEDURE modify_character_stat(
    arg_character INTEGER,
    arg_type INTEGER,
    new_value INTEGER)
AS $$
    UPDATE character_stat SET value = new_value
        WHERE character = arg_character
        AND type = arg_type;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION humans_by_name(arg_name TEXT) RETURNS SETOF human
AS $$
    SELECT * FROM human WHERE name LIKE arg_name;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION tournaments_by_place(arg_place TEXT) RETURNS SETOF tournament
AS $$
    SELECT * FROM tournament WHERE place LIKE arg_place;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION tournament_result_by_human(arg_id INT)
    RETURNS SETOF tournament_result_joined_view
AS $$
    SELECT * FROM tournament_result_joined_view WHERE player = arg_id;
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION tournament_result_by_tournament(arg_id INT)
    RETURNS SETOF tournament_result_joined_view
AS $$
    SELECT * FROM tournament_result_joined_view WHERE tournament = arg_id;
$$ LANGUAGE sql;
