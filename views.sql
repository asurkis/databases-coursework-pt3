CREATE OR REPLACE VIEW human_with_roles_view AS
    SELECT h.*,
        artist.human IS NOT NULL AS is_artist,
        organizer.human IS NOT NULL AS is_organizer,
        player.human IS NOT NULL AS is_player,
        sponsor.human IS NOT NULL AS is_sponsor
    FROM human AS h
        LEFT OUTER JOIN artist ON h.id = artist.human
        LEFT OUTER JOIN organizer ON h.id = organizer.human
        LEFT OUTER JOIN player ON h.id = player.human
        LEFT OUTER JOIN sponsor ON h.id = sponsor.human;

CREATE OR REPLACE VIEW tournament_result_joined_view AS
    SELECT h.id AS player,
            t.id AS tournament,
            h.name,
            tr.score,
            tr.place
        FROM tournament_result AS tr
            JOIN human AS h ON tr.player = h.id
            JOIN tournament AS t ON tr.tournament = t.id;

CREATE OR REPLACE VIEW tournament_rule_set_joined_view AS
    SELECT t.id AS tournament,
        r.id AS rule_set,
        place,
        start_date,
        finish_date,
        organizer,
        r.name AS rule_set_name
    FROM tournament AS t
        JOIN rule_set AS r ON t.rule_set = r.id;

CREATE OR REPLACE VIEW character_rule_set_human_joined_view AS
    SELECT c.*,
        p.name AS player_name,
        r.name AS rule_set_name
    FROM character AS c
        JOIN rule_set AS r ON c.rule_set = r.id
        JOIN human AS p ON c.player = p.id;

CREATE OR REPLACE VIEW character_stat_value_and_type_joined_view AS
    SELECT v.character,
        v.type,
        t.name AS type_name,
        v.value AS value
    FROM character_stat AS v
        JOIN character_stat_type AS t ON v.type = t.id;

CREATE OR REPLACE VIEW sponsor_contract_with_names_view AS
    SELECT c.*,
        o.name AS organizer_name,
        s.name AS sponsor_name
    FROM sponsor_contract AS c
        JOIN human AS o ON c.organizer = o.id
        JOIN human AS s ON c.sponsor = s.id;

CREATE OR REPLACE VIEW game_event_agent_object_joined_view AS
    SELECT g.*,
        a.name AS agent_name,
        o.name AS object_name
    FROM game_event AS g
        JOIN character AS a ON g.agent = a.id
        JOIN character AS o ON g.object = o.id;

CREATE OR REPLACE VIEW artist_performances_joined_view AS
    SELECT a.id AS artist,
        a.name,
        t.id AS tournament
    FROM performance
        JOIN human AS a ON a.id = performance.artist
        JOIN tournament AS t ON t.id = performance.tournament;

CREATE OR REPLACE VIEW rule_with_link AS
    SELECT r.*, t.name AS stat_name
    FROM rule AS r JOIN character_stat_type AS t
        ON r.stat_to_modify = t.id;
