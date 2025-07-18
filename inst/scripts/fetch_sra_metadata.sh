#!/bin/bash

# --- Configuración ---
WORKDIR="../inst/extdata"
INPUT_TSV="training_metadata_cleaned.tsv"
CLEANED_FILE="accessions_cleaned.txt"
CHUNK_PREFIX="accession_chunk_"
OUTPUT_FILE="training_sra_metadata_July172025.csv"

# --- Verifica que Entrez Direct esté disponible ---
if ! command -v esearch &> /dev/null || ! command -v efetch &> /dev/null; then
  echo "Entrez Direct no está correctamente instalado."
  exit 1
fi

cd "$WORKDIR"

# --- Detecta la posición de la columna 'accession' dinámicamente ---
COL_IDX=$(head -1 "$INPUT_TSV" | tr '\t' '\n' | grep -n '^accession$' | cut -d: -f1)

if [ -z "$COL_IDX" ]; then
  echo "No se encontró la columna 'accession' en el archivo $INPUT_TSV"
  exit 1
fi

# --- Extrae accesiones SRR/ERR y limpia pegadas ---
tail -n +2 "$INPUT_TSV" | awk -F '\t' -v idx="$COL_IDX" '{print $idx}' | \
grep -oE 'SRR[0-9]+|ERR[0-9]+' | sort -u > "$CLEANED_FILE"

if [ ! -s "$CLEANED_FILE" ]; then
  echo "No se encontraron accesiones válidas en el archivo: $INPUT_TSV"
  exit 1
fi

# --- Inicializa el archivo de salida ---
> "$OUTPUT_FILE"

# --- Divide accesiones en bloques de 100 ---
split -l 100 "$CLEANED_FILE" "$CHUNK_PREFIX"

# --- Ejecuta consultas por bloque ---
for chunk in ${CHUNK_PREFIX}*; do
  QUERY=$(grep -oE 'SRR[0-9]+|ERR[0-9]+' "$chunk" | tr '\n' '|' | sed 's/|/ OR /g' | sed 's/ OR $//')

  echo "Ejecutando consulta para el bloque: $chunk"
  echo "$QUERY"

  if [ -n "$QUERY" ]; then
    esearch -db sra -query "$QUERY" | efetch -format runinfo >> "$OUTPUT_FILE"
    if [ $? -ne 0 ]; then
      echo "Advertencia: Falló la consulta para el bloque $chunk"
    fi
  fi
done

# --- Validación final ---
if [ -s "$OUTPUT_FILE" ]; then
  echo "Metadatos consolidados en: $OUTPUT_FILE"
else
  echo "No se recuperó información para las accesiones procesadas."
fi

# --- Limpieza temporal opcional ---
rm -f ${CHUNK_PREFIX}*
