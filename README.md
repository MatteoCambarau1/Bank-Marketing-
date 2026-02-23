# Bank Marketing - Analisi di Classificazione in R

## Descrizione

Questo progetto contiene un'analisi statistica e di machine learning applicata al dataset **Bank Marketing** (`bank-full.csv`). L'obiettivo è costruire e confrontare diversi modelli di classificazione per predire se un cliente sottoscriverà un deposito a termine bancario (variabile target `y`).

## Dataset

Il file di input atteso è `bank-full.csv` (separatore `;`), tipicamente disponibile tramite il [UCI Machine Learning Repository](https://archive.ics.uci.edu/ml/datasets/bank+marketing).

Le variabili principali utilizzate nell'analisi sono:

| Variabile | Descrizione |
|-----------|-------------|
| `y` | Variabile target: il cliente ha sottoscritto un deposito? (`yes`/`no`) |
| `duration` | Durata dell'ultimo contatto (secondi) |
| `poutcome` | Esito della campagna precedente |
| `month` | Mese dell'ultimo contatto |
| `contact` | Tipo di contatto |
| `housing` | Mutuo sulla casa |
| `job` | Tipo di lavoro |
| `campaign` | Numero di contatti durante la campagna |
| `marital` | Stato civile |
| `loan` | Prestito personale in corso |
| `day` | Giorno dell'ultimo contatto |
| `education` | Livello di istruzione |

## Struttura del progetto

```
├── Analisi_bank.R     # Script principale di analisi
├── bank-full.csv      # Dataset (da aggiungere manualmente)
└── README.md
```

## Analisi effettuate

### 1. Pre-processing
- Caricamento e ispezione del dataset
- Conversione delle variabili categoriali in `factor`
- Controllo valori mancanti (`NA`)

### 2. Analisi Esplorativa (EDA)
- Scatterplot matrix interattiva con `GGally` e `plotly`
- Grafici a barre e boxplot per esplorare relazioni tra le variabili e la variabile target

### 3. Modelli di Classificazione (Validation Set: 67% train / 33% test)

| Modello | Descrizione |
|--------|-------------|
| **Regressione Logistica** | Selezione variabili stepwise (AIC), predizione con soglia 0.5 |
| **LDA** | Linear Discriminant Analysis, confini decisionali lineari |
| **QDA** | Quadratic Discriminant Analysis, confini decisionali quadratici |

### 4. Cross-Validation (K-Fold con K=5)

| Modello | Accuratezza |
|--------|-------------|
| Regressione Logistica | ~90.2% |
| LDA | ~90.1% |
| KNN (k=9) | ~88.4% |

Il modello migliore viene selezionato tramite il **Misclassification Error (MCE)** minimo.

## Librerie R utilizzate

```r
install.packages(c("ggplot2", "gridExtra", "plotly", "GGally", "MASS", "caret"))
```

## Come eseguire

1. Clona il repository e posiziona il file `bank-full.csv` nella stessa cartella dello script.
2. Apri `Analisi_bank.R` in RStudio.
3. Esegui lo script in sequenza (le librerie verranno installate automaticamente al primo avvio).

## Autore

Progetto sviluppato come esercizio di analisi statistica e classificazione supervisionata in R.
