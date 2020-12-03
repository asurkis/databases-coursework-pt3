INSERT INTO human (name, phone, email, info) VALUES ('Редмонд', '+1-234-56-78', 'redmond@example.com', 'Редмонд Манн');
INSERT INTO human (name, phone, email, info) VALUES ('Блутарх', '+9-876-54-32', 'blutarch@example.com', 'Блутарх Манн');
INSERT INTO human (name, email, info) VALUES ('Грей', 'gray@example.com', 'Грей Манн');
INSERT INTO sponsor (human) SELECT id FROM human WHERE name ~ '^Редмонд$';
INSERT INTO organizer (human) SELECT id FROM human WHERE name ~ '^Блутарх$';
INSERT INTO player (human) SELECT id FROM human;
INSERT INTO artist (human) SELECT id FROM human WHERE name ~ '^Грей$';
INSERT INTO sponsor_contract (sponsor, organizer, info)
    SELECT sponsor.human, organizer.human, 'Текст контракта'
    FROM sponsor CROSS JOIN organizer;
INSERT INTO rule_set (name) VALUES ('TnT');
INSERT INTO character_stat_type (rule_set, name, description)
    SELECT id, 'Здоровье', 'Сколько урона может выдержать персонаж' FROM rule_set;
INSERT INTO character_stat_type (rule_set, name, description)
    SELECT id, 'Сила', 'Физическая сила персонажа' FROM rule_set;
INSERT INTO character_stat_type (rule_set, name, description)
    SELECT id, 'Скорость', 'Количество очков действия за ход' FROM rule_set;
INSERT INTO rule (condition, rule_set, stat_to_modify, action_with_stat, value_of_modification)
    SELECT 'Выпил зелье лечения', rule_set, id, '+', 10 FROM character_stat_type WHERE name ~ '^Здоровье$';
INSERT INTO rule (condition, rule_set, stat_to_modify, action_with_stat, value_of_modification)
    SELECT 'Стоит в болоте', rule_set, id, '/', 2 FROM character_stat_type WHERE name ~ '^Скорость$';
INSERT INTO character (name, rule_set, player)
    SELECT 'Боров', rule_set.id, human.id
    FROM rule_set CROSS JOIN human WHERE human.name ~ '^Редмонд$';
INSERT INTO character (name, rule_set, player)
    SELECT 'Киров', rule_set.id, human.id
    FROM rule_set CROSS JOIN human WHERE human.name ~ '^Блутарх$';
INSERT INTO tournament (place, start_date, finish_date, organizer, rule_set)
    SELECT 'Ул. Пушкина, д. Колотушкина', timestamptz '2020-01-02 09:00', timestamptz '2020-01-02 18:00',
    organizer.human, rule_set.id FROM organizer CROSS JOIN rule_set;
INSERT INTO performance (artist, tournament)
    SELECT artist.human, tournament.id
    FROM artist CROSS JOIN tournament;
INSERT INTO game (tournament) SELECT id FROM tournament;
INSERT INTO game_event (game, agent, object, description, time, rule_applied)
    SELECT game.id, character.id, character.id, '', timestamptz '2020-01-02 15:00', rule.id
        FROM game CROSS JOIN character CROSS JOIN rule
        WHERE character.name ~ '^Боров$' and rule.condition = 'Выпил зелье лечения';
INSERT INTO game_event (game, agent, object, description, time, rule_applied)
    SELECT game.id, character.id, character.id, '', timestamptz '2020-01-02 15:00', rule.id
        FROM game CROSS JOIN character CROSS JOIN rule
        WHERE character.name ~ '^Киров$' and rule.condition = 'Стоит в болоте';
INSERT INTO tournament_result (tournament, player, score, place)
    SELECT tournament.id, human.id, 2, 1
    FROM tournament CROSS JOIN human WHERE human.name ~ '^Редмонд$';
INSERT INTO tournament_result (tournament, player, score, place)
    SELECT tournament.id, human.id, 1, 2
    FROM tournament CROSS JOIN human WHERE human.name ~ '^Блутарх$';
INSERT INTO character_stat_type (rule_set, name, description)
    SELECT rule_set.id, 'Удача', 'Общая удача персонажа' FROM rule_set;
