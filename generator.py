file = open('sample.sql', 'w')
for i in range(1000):
    file.write("""INSERT INTO human (name, phone, email, telegram, vk, info) VALUES
    ('Человек %d', '+7-%03d-%03d-%02d-%02d', 'human%d@example.com', 't.me/human%d', 'vk.com/id%d', 'Пример данных');\n"""
               % (i + 1, i // 10000000 % 1000, i // 10000 % 1000, i // 100 % 100, i // 1 % 100, i + 1, i + 1, i + 1))
file.write("""INSERT INTO sponsor (human) SELECT id FROM human WHERE id
    BETWEEN (SELECT id FROM human WHERE name LIKE 'Человек 1')
    AND (SELECT id FROM human WHERE name LIKE 'Человек 50');\n""")
file.write("""INSERT INTO organizer (human) SELECT id FROM human WHERE id
    BETWEEN (SELECT id FROM human WHERE name LIKE 'Человек 26')
    AND (SELECT id FROM human WHERE name LIKE 'Человек 75');\n""")
file.write("""INSERT INTO artist (human) SELECT id FROM human WHERE id
    BETWEEN (SELECT id FROM human WHERE name LIKE 'Человек 51')
    AND (SELECT id FROM human WHERE name LIKE 'Человек 100');\n""")
file.write("""INSERT INTO player (human) SELECT id FROM human WHERE id
    BETWEEN (SELECT id FROM human WHERE name LIKE 'Человек 76')
    AND (SELECT id FROM human WHERE name LIKE 'Человек 1000');\n""")
file.write("""INSERT INTO sponsor_contract (sponsor, organizer, info)
    SELECT hs.id, ho.id,
        CONCAT('Контракт между спонсором ', hs.name, ' и организатором ', ho.name)
    FROM sponsor JOIN human AS hs ON sponsor.human = hs.id
    CROSS JOIN organizer JOIN human AS ho ON organizer.human = ho.id
    WHERE
        hs.id BETWEEN (SELECT id FROM human WHERE name LIKE 'Человек 1')
        AND (SELECT id FROM human WHERE name LIKE 'Человек 10')
    AND
        ho.id BETWEEN (SELECT id FROM human WHERE name LIKE 'Человек 51')
        AND (SELECT id FROM human WHERE name LIKE 'Человек 75');""")
for i in range(10):
    file.write("INSERT INTO rule_set (name) VALUES ('Набор правил %d');\n" % (i + 1));
for i in range(10):
    file.write("""INSERT INTO character_stat_type (rule_set, name, description, default_value)
    SELECT id, 'Характеристика %d', CONCAT('Характеристика %d из набора правил ', name), 100 FROM rule_set;\n""")
file.write("""INSERT INTO rule (rule_set, condition, stat_to_modify, action_with_stat, value_of_modification)
    SELECT rule_set, CONCAT(name, ' + 1'), id, '+', 1 FROM character_stat_type;\n""")
file.write("""INSERT INTO rule (rule_set, condition, stat_to_modify, action_with_stat, value_of_modification)
    SELECT rule_set, CONCAT(name, ' - 1'), id, '-', 1 FROM character_stat_type;\n""")
file.write("""INSERT INTO rule (rule_set, condition, stat_to_modify, action_with_stat, value_of_modification)
    SELECT rule_set, CONCAT(name, ' * 2'), id, '*', 2 FROM character_stat_type;\n""")
file.write("""INSERT INTO rule (rule_set, condition, stat_to_modify, action_with_stat, value_of_modification)
    SELECT rule_set, CONCAT(name, ' / 2'), id, '/', 2 FROM character_stat_type;\n""")
file.write("""INSERT INTO character (name, rule_set, player)
    SELECT CONCAT('Персонаж игрока ', human.name, ' в наборе правил ', rule_set.name), rule_set.id, human.id
    FROM player JOIN human ON player.human = human.id CROSS JOIN rule_set;\n""")
for i in range(50):
    file.write("""INSERT INTO tournament (place, start_date, finish_date, organizer, rule_set)
    SELECT 'Улица Пушкина, дом Колотушкина', TIMESTAMPTZ '2020-%02d-%02d', TIMESTAMPTZ '2020-%02d-%02d', human.id, rule_set.id
    FROM organizer JOIN human ON organizer.human = human.id CROSS JOIN rule_set
    WHERE human.name LIKE 'Человек %d' AND rule_set.name LIKE 'Набор правил %d';\n"""
              % (i // 28 + 1, i % 28 + 1, (i + 1) // 28 + 1, (i + 1) % 28 + 1,
                i % 50 + 1, i % 10 + 1))
file.write("""INSERT INTO performance (artist, tournament)
    SELECT human.id, tournament.id
    FROM artist JOIN human ON artist.human = human.id CROSS JOIN tournament
    WHERE human.id
        BETWEEN (SELECT id FROM human WHERE name LIKE 'Человек 51')
        AND (SELECT id FROM human WHERE name LIKE 'Человек 60');\n""")
for i in range(5):
    file.write("""INSERT INTO game (tournament) SELECT id FROM tournament;\n""")
file.write("""INSERT INTO game_event (game, agent, object, description, time, rule_applied)
    SELECT game.id, character.id, character.id, '', TIMESTAMPTZ '2020-01-01', rule.id
    FROM game JOIN tournament ON game.tournament = tournament.id
    JOIN rule_set ON tournament.rule_set = rule_set.id
    JOIN character ON character.rule_set = rule_set.id
    JOIN rule ON rule.rule_set = rule_set.id
    JOIN player ON character.player = player.human
    JOIN human ON player.human = human.id
    WHERE rule.action_with_stat LIKE '+' AND human.id
        BETWEEN (SELECT id FROM human WHERE name LIKE 'Человек 991')
        AND (SELECT id FROM human WHERE name LIKE 'Человек 1000');\n""")
file.write("""INSERT INTO tournament_result (tournament, player, score)
    SELECT tournament.id, player.human, MAX(character_stat.value)
    FROM tournament CROSS JOIN player
    JOIN character ON player.human = character.player AND tournament.rule_set = character.rule_set
    JOIN character_stat ON character_stat.character = character.id
    GROUP BY (tournament.id, player.human);""")
file.close()
