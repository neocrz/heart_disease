# Heart Disease — Análise de Fatores Clínicos

**Idioma:** [English](README.md) · Português (Brasil)

Análise exploratória e preditiva do conjunto de dados **UCI Heart Disease (Cleveland)**.
O projeto investiga como variáveis clínicas e demográficas se relacionam com a presença
de doença coronária e compara cinco modelos de classificação para a tarefa de diagnóstico.

A análise completa está em [`note.ipynb`](note.ipynb).

## Visão geral

- **Objetivo:** identificar quais variáveis clínicas estão associadas à doença cardíaca
  angiográfica e avaliar a capacidade de diferentes classificadores em prevê-la.
- **Dados:** 303 pacientes, 13 variáveis preditoras e 1 variável alvo binária.
- **Métodos:** análise de distribuições, V de Cramér (categóricas), ANOVA (numéricas),
  mapa de correlação e cinco modelos supervisionados.
- **Resultado:** o `Random Forest` teve o melhor desempenho (86% de acurácia, AUC 0.921);
  o tipo de dor no peito e a condição cardíaca foram as variáveis mais associadas ao
  diagnóstico.

## Conjunto de dados

| Item | Valor |
| --- | --- |
| Nome | Heart Disease |
| Fonte | [UCI ML Repository — dataset 45](https://archive.ics.uci.edu/dataset/45/heart+disease) |
| Pacientes | 303 |
| Variáveis | 13 |
| Alvo | `num` — 0 = sem doença (164), 1 = com doença (139) |
| Valores ausentes | Nenhum nos CSVs em cache (imputados durante o carregamento) |
| Licença | [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode) |

A coluna original `num` possui valores de 0 a 4. Ela é binarizada em `0` (sem doença) e
`1` (qualquer grau de doença). Quando o conjunto bruto é baixado, `ca` é preenchida com a
média e `thal` com a moda.

### Variáveis

| Coluna | Significado | Tipo |
| --- | --- | --- |
| `age` | Idade (anos) | Numérica |
| `sex` | Sexo (0 = feminino, 1 = masculino) | Categórica |
| `cp` | Tipo de dor no peito (1–4) | Categórica |
| `trestbps` | Pressão arterial em repouso (mm Hg) | Numérica |
| `chol` | Colesterol sérico (mg/dL) | Numérica |
| `fbs` | Glicemia em jejum > 120 mg/dL | Categórica |
| `restecg` | Resultados do ECG em repouso (0–2) | Categórica |
| `thalach` | Frequência cardíaca máxima atingida (bpm) | Numérica |
| `exang` | Angina induzida por exercício | Categórica |
| `oldpeak` | Depressão do segmento ST induzida por exercício (mm) | Numérica |
| `slope` | Inclinação do segmento ST no pico (1–3) | Categórica |
| `ca` | Número de vasos principais (0–3) | Numérica |
| `thal` | Condição cardíaca (3, 6, 7) | Categórica |
| `num` | Diagnóstico — variável alvo | Categórica |

As descrições das colunas estão disponíveis em [`data_dict.csv`](data_dict.csv) (inglês)
e [`data_dict_pt.csv`](data_dict_pt.csv) (português).

## Estrutura do repositório

```
.
├── note.ipynb            # Notebook completo da análise (EDA + estatística + modelos)
├── data/
│   ├── datasetX.csv      # Matriz de variáveis em cache (303 × 13)
│   └── datasety.csv      # Coluna alvo em cache (303 × 1)
├── data_dict.csv         # Dicionário de dados (inglês)
├── data_dict_pt.csv      # Dicionário de dados (português)
├── flake.nix             # Ambiente Nix com Python 3.11 + bibliotecas científicas
├── ucimlrepo.nix         # Definição local do pacote ucimlrepo
├── .envrc                # Integração com direnv (`use flake`)
├── README.md             # Documentação em inglês
└── README.pt-BR.md       # Documentação em português (Brasil)
```

## Metodologia

1. **Carregamento e limpeza** — carrega os CSVs em cache ou busca os dados no UCI com
   `ucimlrepo` e imputa os valores ausentes quando o cache não existe. O conjunto
   binarizado é então salvo em `data/`.
2. **Análise exploratória** — histogramas e KDE para variáveis numéricas, gráficos de
   barras para categóricas e distribuição da variável alvo.
3. **Estatística inferencial**
   - V de Cramér (via qui-quadrado) para medir a associação entre variáveis categóricas
     e o alvo.
   - ANOVA de uma via para comparar as médias das variáveis numéricas entre os grupos
     de diagnóstico.
   - Mapa de correlação combinando coeficientes de Pearson (numéricas) e V de Cramér
     (categóricas) em relação ao alvo.
4. **Modelagem** — divisão treino/teste de 70/30 (`random_state=42`, 212 treino /
   91 teste). A Regressão Logística usa um `ColumnTransformer` com `StandardScaler` e
   `OneHotEncoder`; os demais modelos são treinados na matriz de variáveis bruta.
5. **Avaliação** — relatório de classificação (precisão, recall, F1), acurácia, AUC-ROC,
   curvas ROC, matrizes de confusão e importância das variáveis do Random Forest.

## Modelos e resultados

| Modelo | Acurácia | F1 macro | AUC-ROC |
| --- | :---: | :---: | :---: |
| Regressão Logística | 0.81 | 0.81 | 0.896 |
| Árvore de Decisão | 0.77 | 0.77 | 0.753 |
| **Random Forest** | **0.86** | **0.86** | **0.921** |
| Naive Bayes Gaussiano | 0.80 | 0.80 | 0.881 |
| Rede Neural (MLP 50-30) | 0.70 | 0.70 | 0.833 |

## Principais achados

- **Maiores associações com o diagnóstico:** tipo de dor no peito (`cp`, V = 0.520) e
  condição cardíaca (`thal`, V = 0.522), seguidas por angina induzida por exercício
  (`exang`, 0.425) e inclinação do segmento ST (`slope`, 0.389).
- **Diferenças numéricas significativas** entre os grupos de diagnóstico: idade,
  pressão arterial em repouso, frequência cardíaca máxima, depressão do segmento ST e
  número de vasos (p < 0.05).
- **O colesterol (`chol`) não foi significativo** (p = 0.139) e apresentou baixo poder
  discriminativo nesta amostra.
- O **Random Forest** obteve o melhor equilíbrio entre acurácia e AUC. Suas variáveis
  mais importantes foram dor no peito (0.149), condição cardíaca (0.147), número de
  vasos (0.139) e frequência cardíaca máxima (0.104).

## Como começar

### Requisitos

- [Nix](https://nixos.org/) com flakes habilitados (recomendado) ou Python 3.11 com os
  pacotes listados em `flake.nix`.

### Configuração

```bash
# Opção A: direnv
direnv allow

# Opção B: entrar diretamente no ambiente de desenvolvimento
nix develop
```

O ambiente fornece JupyterLab, pandas, NumPy, SciPy, scikit-learn, seaborn, matplotlib,
imbalanced-learn, XGBoost e o pacote `ucimlrepo` empacotado localmente.

### Executar a análise

```bash
jupyter lab note.ipynb
```

Se `data/datasetX.csv` e `data/datasety.csv` não existirem, o notebook baixa o conjunto
de dados do UCI, faz a limpeza e salva os dois arquivos em `data/`.

## Limitações e próximos passos

- Amostra pequena (303 pacientes) e uma única divisão holdout; validação cruzada
  forneceria estimativas mais estáveis.
- Ausência de ajuste sistemático de hiperparâmetros.

## Licença

O conjunto de dados é distribuído sob a licença
[CC BY 4.0](https://creativecommons.org/licenses/by/4.0/legalcode).
