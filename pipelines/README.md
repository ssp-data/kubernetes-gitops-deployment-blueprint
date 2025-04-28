# Data Pipelines

This directory contains data pipeline definitions for the data platform, using Kestra as the orchestrator and dlt (data load tool) for data integration.

## Directory Structure

```
pipelines/
├── chess-kestra-dlt.yml   # Kestra workflow definition for chess data pipeline
├── dlt/                   # Data integration scripts using dlt
│   └── dlt-chess-snowflake.py # Script to load chess.com data into Snowflake
└── README.md              # This documentation file
```

## Pipeline Components

### 1. Data Integration with dlt

The `dlt/` directory contains Python scripts that use the dlt framework to:
- Extract data from source systems (APIs, databases, files, etc.)
- Apply basic transformations and data quality checks
- Load data into target destinations (Snowflake, BigQuery, etc.)
- Track pipeline state and provide incremental loading

Each dlt script:
- Defines source data extractors
- Handles data type mapping
- Manages schema evolution
- Provides error handling and retries

### 2. Orchestration with Kestra

The `.yml` files in the root directory define Kestra workflows that:
- Schedule and trigger pipeline execution
- Manage dependencies between tasks
- Handle secrets and environment variables
- Provide monitoring and notifications
- Support error handling and retries

## Adding a New Pipeline

To add a new data pipeline:

1. **Create dlt Script**: Develop a Python script in the `dlt/` directory that defines:
   - Source data extractors
   - Data transformations
   - Loading configuration

2. **Create Kestra Workflow**: Define a Kestra workflow YAML file that:
   - Sets up dependencies and environment
   - Runs the dlt script
   - Handles secrets and configuration
   - Manages error handling and notifications

3. **Update Deployment Configuration**: Modify the appropriate Kubernetes manifests in the domain directory to deploy Kestra and required dependencies

## Pipeline Deployment

Pipelines are deployed as part of the GitOps workflow:

1. Code is committed to Git
2. CI/CD pipeline updates configurations
3. Flux detects changes and applies them to the cluster
4. Kestra schedules and executes the pipeline based on defined triggers

## Example Pipeline

Our example chess data pipeline includes:

- Extraction of player data from the Chess.com API
- Loading data directly into Snowflake tables
- Orchestration with Kestra
- Secret management for database credentials

## Testing Pipelines

To test pipelines locally:

```bash
# Set up environment variables
export DESTINATION__SNOWFLAKE_HOST=your-account.snowflakecomputing.com
export DESTINATION__SNOWFLAKE_PASSWORD=your-password

# Test dlt script
cd pipelines/dlt
python dlt-chess-snowflake.py

# Validate Kestra workflow
kestra flow validate ../chess-kestra-dlt.yml
```

## Monitoring and Observability

Kestra provides built-in monitoring capabilities:

- Flow execution history and logs
- Task success/failure metrics
- Execution time tracking
- Notification integrations (Slack, email, etc.)

Additionally, dlt generates detailed logs and metrics that can be integrated with the platform's observability stack.