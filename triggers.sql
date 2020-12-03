CREATE OR REPLACE FUNCTION setup_default_character_stats() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO character_stat (character, type, value)
        SELECT NEW.id, character_stat_type.id, character_stat_type.default_value
            FROM character_stat_type WHERE NEW.rule_set = character_stat_type.rule_set;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_default_stat() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO character_stat (character, type, value)
        SELECT character.id, NEW.id, NEW.default_value
            FROM character WHERE NEW.rule_set = character.rule_set;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION process_game_event() RETURNS TRIGGER AS $$
BEGIN
    with old as
        (SELECT case
                when action_with_stat = '+' then value + value_of_modification
                when action_with_stat = '-' then value - value_of_modification
                when action_with_stat = '*' then value * value_of_modification
                when action_with_stat = '/' then value / value_of_modification
                else NULL END as newval, type
            FROM character_stat join rule on character_stat.type = rule.stat_to_modify
            WHERE NEW.rule_applied = rule.id and NEW.object = character)
    update character_stat set value = (SELECT newval FROM old)
        WHERE NEW.object = character and type = (SELECT type FROM old);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_character_stats AFTER INSERT ON character
    FOR EACH ROW EXECUTE FUNCTION setup_default_character_stats();
CREATE TRIGGER trigger_new_stat AFTER INSERT ON character_stat_type
    FOR EACH ROW EXECUTE FUNCTION add_default_stat();
CREATE TRIGGER trigger_game_event AFTER INSERT ON game_event
    FOR EACH ROW EXECUTE FUNCTION process_game_event();
