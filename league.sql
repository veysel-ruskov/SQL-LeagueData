CREATE DATABASE League;

CREATE TABLE Profile (
    RiotID int identity(1,1) PRIMARY KEY,
    Username nvarchar(255) not null,
    Icons int not null,
	Levels nvarchar(255) not null,
	TopChampions nvarchar(255) not null,
	KDA float(2) not null,
	Collections nvarchar(255) not null
);
ALTER TABLE Profile
DROP COLUMN Icons;

ALTER TABLE Profile
DROP COLUMN Levels;

ALTER TABLE Profile
ADD Icons nvarchar(255) not null;

ALTER TABLE Profile
ADD Levels int not null;


CREATE TABLE Conservation (
	ReciverUsername nvarchar(255) PRIMARY KEY,
	Subj nvarchar(255) not null,
	RiotID int FOREIGN KEY REFERENCES Profile(RiotID),
);

CREATE TABLE ConservationReplay (
	SenderUsername nvarchar(255) PRIMARY KEY,
	IsSeen bit not null,
	ReciverUsername nvarchar(255) FOREIGN KEY REFERENCES Conservation(ReciverUsername),
	TextMessage nvarchar(255) not null
);

ALTER TABLE Conservation
ADD SenderUsername nvarchar(255) FOREIGN KEY REFERENCES ConservationReplay(SenderUsername);

CREATE TABLE GameStatus (
	RiotID int FOREIGN KEY REFERENCES Profile(RiotID),
	statInGame bit not null,
	statOnline bit not null,
	statInQueue bit not null,
	statChampionSelect bit not null,
	statAway bit not null,
	statLeague bit not null,
);

CREATE TABLE AddFriend (
	RiotID int FOREIGN KEY REFERENCES Profile(RiotID),
	Username nvarchar(255) not null,
	GameID int not null
);

CREATE TABLE MatchHistory (
	RiotID int FOREIGN KEY REFERENCES Profile(RiotID),
	Champion nvarchar(255) not null,
	RunesAndSpells nvarchar(255) not null,
	GameType nvarchar(255) not null,
	Items nvarchar(255) not null,
	StatsKDA float(2) not null,
	TimePlayed int not null
);

INSERT INTO Conservation(ReciverUsername, Subj, RiotID)
VALUES ('TestAcount3', 'Play', 1);



INSERT INTO ConservationReplay(SenderUsername, IsSeen, ReciverUsername, TextMessage)
VALUES ('TestAcount', 1, 'TestAcount3', 'Wanna play?')

INSERT INTO AddFriend(RiotID, Username, GameID)
VALUES (1, 'TestAccount3', 3)

INSERT INTO GameStatus(RiotID, statInGame, statOnline, statInQueue, statChampionSelect, statAway, statLeague)
VALUES (1, 0, 0, 0, 0, 1, 0)


//*procedure*//

CREATE PROCEDURE CreateProfile(
    @Username nvarchar(255),
    @Icons nvarchar(255),
	@Levels int,
	@TopChampions nvarchar(255),
	@KDA float(2),
	@Collections nvarchar(255))
AS
BEGIN
	INSERT INTO Profile(Username, Icons, Levels, TopChampions, KDA, Collections)
	VALUES(@Username, @Icons, @Levels, @TopChampions, @KDA, @Collections);
END;


EXEC CreateProfile
@Username = "TestAcount34",
@Icons = "Welcome icon, Master icon,asd",
@Levels = 0,
@TopChampions = "2 games",
@KDA = 0,
@Collections = "No collections";

SELECT * FROM Profile

CREATE PROCEDURE CreateMatch(
	@RiotID int,
	@Champion nvarchar(255),
	@RunesAndSpells nvarchar(255),
	@GameType nvarchar(255),
	@Items nvarchar(255),
	@StatsKDA float(2),
	@TimePlayed int)
AS
BEGIN
	INSERT INTO MatchHistory(RiotID, Champion, RunesAndSpells, GameType, Items, StatsKDA, TimePlayed)
	VALUES(@RiotID, @Champion, @RunesAndSpells, @GameType, @Items, @StatsKDA, @TimePlayed);
END;


EXEC CreateMatch
@RiotID = 2,
@Champion = "Lulu",
@RunesAndSpells = "Flash",
@GameType = "Ranked",
@Items = "Manamune",
@StatsKDA = 3.55,
@TimePlayed = 25
;

SELECT * FROM MatchHistory

//*triger*//

CREATE TABLE Logx(
info nvarchar(255)
);

CREATE TRIGGER ProfileChanges
ON Profile
AFTER UPDATE
AS 
BEGIN
	DECLARE @OldUsername AS nvarchar(255) = (SELECT Username FROM deleted);
	DECLARE @OldIcons AS nvarchar(255) = (SELECT Icons FROM deleted);
	DECLARE @OldTopChamions AS nvarchar(255) = (SELECT TopChampions FROM deleted);
	DECLARE @OldCollections AS nvarchar(255) = (SELECT Collections FROM deleted);

	DECLARE @NewUsername AS nvarchar(255) = (SELECT Username FROM inserted);
	DECLARE @NewIcons AS nvarchar(255) = (SELECT Icons FROM inserted);
	DECLARE @NewTopChamions AS nvarchar(255) = (SELECT TopChampions FROM inserted);
	DECLARE @NewCollections AS nvarchar(255) = (SELECT Collections FROM inserted);


	INSERT INTO Logx(info)
	VALUES('Old: ' + @OldUsername + ','+@OldIcons + ','+@OldTopChamions + ','+@OldCollections +' ' +
	'New: ' + @NewUsername + ','+@NewIcons + ','+@NewTopChamions + ','+@NewCollections);
END;

drop TRIGGER ProfileChanges

UPDATE Profile
SET Icons = 'Master icon'
WHERE RiotID = 1

Select * from Logx

CREATE TRIGGER ProfileChangesDelete
ON Profile
AFTER DELETE
AS 
BEGIN
	DECLARE @Username AS nvarchar(255)
	DECLARE @Icons AS nvarchar(255)
	DECLARE @TopChamions AS nvarchar(255)
	DECLARE @Collections AS nvarchar(255)
	INSERT INTO Logx(info)
	VALUES(@Username + ','+@Icons + ','+@TopChamions + ','+@Collections +'was deleted');
END;
drop TRIGGER ProfileChangesDelete

CREATE TRIGGER ProfileChangesInsert
ON Profile
AFTER INSERT
AS 
BEGIN
	DECLARE @Username AS nvarchar(255)
	DECLARE @Icons AS nvarchar(255)
	DECLARE @TopChamions AS nvarchar(255)
	DECLARE @Collections AS nvarchar(255)
	INSERT INTO Logx(info)
	VALUES(@Username + ','+@Icons + ','+@TopChamions + ','+@Collections +'was inserted');
END;