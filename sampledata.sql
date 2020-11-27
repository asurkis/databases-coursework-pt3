insert into human (name, phone, email, info) values ('Редмонд', '+1-234-56-78', 'redmond@example.com', 'Редмонд Манн');
insert into human (name, phone, email, info) values ('Блутарх', '+9-876-54-32', 'blutarch@example.com', 'Блутарх Манн');
insert into human (name, email, info) values ('Грей', 'gray@example.com', 'Грей Манн');
insert into sponsor (human) select id from human where name ~ '^Редмонд$';
insert into organizer (human) select id from human where name ~ '^Блутарх$';
insert into player (human) select id from human;
insert into artist (human) select id from human where name ~ '^Грей$';
insert into sponsor_contract (sponsor, organizer, info)
    select sponsor.human, organizer.human, 'Текст контракта'
    from sponsor cross join organizer;
insert into rule_set (name) values ('TnT');
insert into character_stat_type (rule_set, name, description)
    select id, 'Здоровье', 'Сколько урона может выдержать персонаж' from rule_set;
insert into character_stat_type (rule_set, name, description)
    select id, 'Сила', 'Физическая сила персонажа' from rule_set;
insert into character_stat_type (rule_set, name, description)
    select id, 'Скорость', 'Количество очков действия за ход' from rule_set;
insert into rule (condition, stat_to_modify, action_with_stat, value_of_modification)
    select 'Выпил зелье лечения', id, '+', 10 from character_stat_type where name ~ '^Здоровье$';
insert into rule (condition, stat_to_modify, action_with_stat, value_of_modification)
    select 'Стоит в болоте', id, '/', 2 from character_stat_type where name ~ '^Скорость$';
insert into rule_in_set (rule_set, rule)
    select rule_set.id, rule.id
    from rule_set
        join character_stat_type on rule_set.id = character_stat_type.rule_set
        join rule on character_stat_type.id = rule.stat_to_modify;
insert into character (name, rule_set, player)
    select 'Боров', rule_set.id, human.id
    from rule_set cross join human where human.name ~ '^Редмонд$';
insert into character (name, rule_set, player)
    select 'Киров', rule_set.id, human.id
    from rule_set cross join human where human.name ~ '^Блутарх$';
insert into tournament (place, start_date, finish_date, organizer, rule_set)
    select 'Ул. Пушкина, д. Колотушкина', timestamptz '2020-01-02 09:00', timestamptz '2020-01-02 18:00',
    organizer.human, rule_set.id from organizer cross join rule_set;
insert into performance (artist, tournament)
    select artist.human, tournament.id
    from artist cross join tournament;
insert into game (tournament) select id from tournament;
insert into game_event (game, agent, object, description, time, rule_applied)
    select game.id, character.id, character.id, '', timestamptz '2020-01-02 15:00', rule.id
        from game cross join character cross join rule
        where character.name ~ '^Боров$' and rule.condition = 'Выпил зелье лечения';
insert into game_event (game, agent, object, description, time, rule_applied)
    select game.id, character.id, character.id, '', timestamptz '2020-01-02 15:00', rule.id
        from game cross join character cross join rule
        where character.name ~ '^Киров$' and rule.condition = 'Стоит в болоте';
insert into tournament_result (tournament, player, score, place)
    select tournament.id, human.id, 2, 1
    from tournament cross join human where human.name ~ '^Редмонд$';
insert into tournament_result (tournament, player, score, place)
    select tournament.id, human.id, 1, 2
    from tournament cross join human where human.name ~ '^Блутарх$';
insert into character_stat_type (rule_set, name, description)
    select rule_set.id, 'Удача', 'Общая удача персонажа' from rule_set;
