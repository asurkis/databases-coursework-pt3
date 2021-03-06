CREATE TABLE human(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT,
    email TEXT,
    telegram TEXT,
    vk TEXT,
    info TEXT NOT NULL
);

CREATE TABLE sponsor(human INTEGER PRIMARY KEY REFERENCES human);
CREATE TABLE organizer(human INTEGER PRIMARY KEY REFERENCES human);
CREATE TABLE player(human INTEGER PRIMARY KEY REFERENCES human);
CREATE TABLE artist(human INTEGER PRIMARY KEY REFERENCES human);

CREATE TABLE sponsor_contract(
    id SERIAL PRIMARY KEY,
    sponsor INTEGER REFERENCES sponsor,
    organizer INTEGER REFERENCES organizer,
    info TEXT NOT NULL
);

CREATE TABLE rule_set(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE character_stat_type(
    id SERIAL PRIMARY KEY,
    rule_set INTEGER REFERENCES rule_set,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    default_value INTEGER NOT NULL DEFAULT 100
);

CREATE TABLE rule(
    id SERIAL PRIMARY KEY,
    rule_set INTEGER REFERENCES rule_set,
    condition TEXT NOT NULL,
    stat_to_modify INTEGER REFERENCES character_stat_type,
    action_with_stat TEXT NOT NULL,
    value_of_modification INTEGER NOT NULL
);

CREATE TABLE character(
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    rule_set INTEGER REFERENCES rule_set,
    player INTEGER REFERENCES player
);

CREATE TABLE character_stat(
    character INTEGER REFERENCES character,
    type INTEGER REFERENCES character_stat_type,
    value INTEGER NOT NULL
);

CREATE TABLE tournament(
    id SERIAL PRIMARY KEY,
    place TEXT NOT NULL,
    start_date TIMESTAMPTZ NOT NULL,
    finish_date TIMESTAMPTZ NOT NULL,
    organizer INTEGER REFERENCES organizer,
    rule_set INTEGER REFERENCES rule_set
);

CREATE TABLE performance(
    artist INTEGER REFERENCES artist,
    tournament INTEGER REFERENCES tournament,
    PRIMARY KEY (artist, tournament)
);

CREATE TABLE game(
    id SERIAL PRIMARY KEY,
    tournament INTEGER REFERENCES tournament
);

CREATE TABLE game_event(
    id SERIAL PRIMARY KEY,
    game INTEGER REFERENCES game,
    agent INTEGER REFERENCES character,
    object INTEGER REFERENCES character,
    description TEXT NOT NULL,
    time TIMESTAMPTZ NOT NULL,
    rule_applied INTEGER REFERENCES rule
);

CREATE TABLE tournament_result(
    tournament INTEGER REFERENCES tournament,
    player INTEGER REFERENCES player,
    score INTEGER,
    place INTEGER,
    PRIMARY KEY (tournament, player)
);
