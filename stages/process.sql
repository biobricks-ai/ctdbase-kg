COPY (
	SELECT
		ROW_NUMBER() OVER () as _ROW_NUMBER,
		ChemicalName,
		ChemicalID,
		CasRN,
		GeneSymbol,
		CAST( GeneID AS INTEGER) AS GeneID ,
		GeneForms,
		unnest(str_split_regex(GeneForms, '\|')) as GeneForm,
		Organism,
		CAST( OrganismID AS INTEGER ) AS OrganismID,
		Interaction,
		InteractionActions,
		-- Split InteractionActions on '|' then '^'
		unnest(
			list_transform(
				str_split_regex(InteractionActions, '\|'),
				each_interaction ->
					list_transform(
						[ str_split_regex(each_interaction, '\^') ],
						pair ->
							{
								'InteractionActions_Degree': pair[1],
								'InteractionActions_Type'  : pair[2],
							}
					)
			),
			recursive := true
		),
		PubMedIDs,
		unnest(str_split_regex(PubMedIDs, '\|')) as PubMedID
	FROM 'data-source/ctdbase/CTD_chem_gene_ixns.parquet'
)
TO 'data-processed/ctdbase/CTD_chem_gene_ixns.parquet'
(FORMAT 'parquet')
;
