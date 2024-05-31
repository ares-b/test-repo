SELECT
    SOURCE_TABLE.POL_PARTIES_ROLE_ID            AS ID_ROLE_TIERS,
    SOURCE_TABLE.FROM_EFFECT                    AS DATEDEBUT,
    SOURCE_TABLE.THRU_EFFECT                    AS DATEFIN,
    SOURCE_TABLE.POLICY_ID                      AS ID_CONTRAT,
    SOURCE_TABLE.PARTY_ID                       AS ID_TIERS,
    SOURCE_TABLE.POL_PARTY_ROLE                 AS ROLE_TIERS,
    SOURCE_TABLE.ELT_NETWORK_ID                 AS ID_APPORTEUR,
    SOURCE_TABLE.EFFECTIVESTARTDATE             AS EFFECTIVESTARTDATE,
    SOURCE_TABLE.EFFECTIVEENDDATE               AS EFFECTIVEENDDATE,
    SYSDATE                                     AS LASTMODIFIED,
    SYSDATE                                     AS CREATEDDATE
FROM
    OWN_24456_ODS.RF_KVIC_CRE_CRE_POLICY_PARTIES_ROLES SOURCE_TABLE
WHERE
    EXISTS (
        SELECT
            1
        FROM
            OWN_24456_ODS.DH_KSTR_CONTRATEPARGNE CONTRATEPARGNE
        WHERE SOURCE_TABLE.POLICY_ID = CONTRATEPARGNE.ID_CONTRAT
    )
    AND
    NOT EXISTS (
        SELECT
            1
        FROM
            OWN_24456_ODS.DH_KSTR_ROLECONTRATPERSONNE TARGET_TABLE
        WHERE
            SOURCE_TABLE.PARTY_ID = TARGET_TABLE.ID_TIERS
            AND
            SOURCE_TABLE.POLICY_ID = TARGET_TABLE.ID_CONTRAT
            AND
            SOURCE_TABLE.LASTMODIFIED >= (
                SELECT
                    DAT_VAL
                FROM
                    parametrage
            )
            AND
            SOURCE_TABLE.POL_PARTIES_ROLE_ID = TARGET_TABLE.ID_ROLE_TIERS
            AND
            SOURCE_TABLE.FROM_EFFECT = TARGET_TABLE.DATEDEBUT
            AND
            SOURCE_TABLE.THRU_EFFECT = TARGET_TABLE.DATEFIN
            AND
            SOURCE_TABLE.POL_PARTY_ROLE = TARGET_TABLE.ROLE_TIERS
            AND
            SOURCE_TABLE.ELT_NETWORK_ID = TARGET_TABLE.ID_APPORTEUR            
    )
