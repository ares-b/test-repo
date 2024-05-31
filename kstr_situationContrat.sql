SELECT
    SOURCE_TABLE.POL_POSITION_ID                        AS 'ID_SITUATION',
    SOURCE_TABLE.POLICY_ID                              AS 'ID_CONTRAT',
    SOURCE_TABLE.STATUS                                 AS 'STATUT',
    SOURCE_TABLE.CREATION_DATE                          AS 'DATE_CREATION',
    SOURCE_TABLE.EFFECT_DATE                            AS 'DATE_EFFET',
    SOURCE_TABLE.REAL_NET_AMOUNT                        AS 'VAC_NETTE_REAL',
    SOURCE_TABLE.EFFECTIVESTARTDATE                     AS 'EFFECTIVESTARTDATE',
    SOURCE_TABLE.EFFECTIVEENDDATE                       AS 'EFFECTIVEENDDATE',
    SYSDATE                                             AS 'LASTMODIFIED',
    SYSDATE                                             AS 'CREATEDDATE'
FROM
    OWN_24456_ODS.RF_KVIC_CRE_CRE_POSITIONS SOURCE_TABLE
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
            OWN_24456_ODS.DH_KSTR_SITUATIONCONTRAT TARGET_TABLE
        WHERE
            SOURCE_TABLE.POL_POSITION_ID = TARGET_TABLE.ID_SITUATION
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
            SOURCE_TABLE.STATUS = TARGET_TABLE.STATUT
            AND
            SOURCE_TABLE.CREATION_DATE = TARGET_TABLE.DATE_CREATION
            AND
            SOURCE_TABLE.EFFECT_DATE = TARGET_TABLE.DATE_EFFET
            AND
            SOURCE_TABLE.REAL_NET_AMOUNT = TARGET_TABLE.VAC_NETTE_REAL
    )
