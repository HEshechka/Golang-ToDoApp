CREATE SCHEMA todoapp;

CREATE TABLE todoapp.users
(
    id           bigserial PRIMARY KEY,
    version      bigint NOT NULL DEFAULT 1,
    full_name    text   NOT NULL CHECK (CHAR_LENGTH(full_name) BETWEEN 3 AND 100),
    phone_number varchar(15) CHECK (phone_number ~ '^\+[0-9]+$' AND CHAR_LENGTH (phone_number) BETWEEN 10 AND 15
)
    );

CREATE TABLE todoapp.tasks
(
    id             bigserial PRIMARY KEY,
    version        bigint       NOT NULL DEFAULT 1,
    title          varchar(100) NOT NULL CHECK ( CHAR_LENGTH(title) BETWEEN 1 AND 100),
    description    text CHECK ( CHAR_LENGTH(description) BETWEEN 1 AND 1000),
    completed      boolean,
    created_at     timestamptz  NOT NULL,
    completed_at   timestamptz,
    author_user_id integer      NOT NULL
        REFERENCES todoapp.users (id),

    CHECK (
        (completed = FALSE AND completed_at IS NULL)
            OR (completed = TRUE AND completed_at IS NOT NULL AND completed_at >= created_at)
        )
);