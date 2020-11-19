create or replace function setup_default_character_stats() returns trigger as $$
begin
    insert into character_stat (character, type, value)
        select NEW.id, character_stat_type.id, 100
            from character_stat_type where NEW.rule_set = character_stat_type.rule_set;
    return NEW;
end;
$$ language plpgsql;

create or replace function process_game_event() returns trigger as $$
begin
    with old as
        (select case
                when action_with_stat = '+' then value + value_of_modification
                when action_with_stat = '-' then value - value_of_modification
                when action_with_stat = '*' then value * value_of_modification
                when action_with_stat = '/' then value / value_of_modification
                else NULL end as newval, type
            from character_stat join rule on character_stat.type = rule.stat_to_modify
            where NEW.rule_applied = rule.id and NEW.object = character)
    update character_stat set value = (select newval from old)
        where NEW.object = character and type = (select type from old);
    return NEW;
end;
$$ language plpgsql;

create trigger trigger_character_stats after insert on character
    for each row execute function setup_default_character_stats();
create trigger trigger_game_event after insert on game_event
    for each row execute function process_game_event();
