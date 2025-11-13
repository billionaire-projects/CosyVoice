#!/bin/bash
#
# CosyVoice TTS FastAPI Service Startup Script
# This script starts the CosyVoice FastAPI server for use with TEN Agent
#

set -e

# Configuration
PORT=${COSYVOICE_PORT:-50000}
# MODEL_DIR=${COSYVOICE_MODEL_DIR:-"pretrained_models/CosyVoice2-0.5B"}
MODEL_DIR=${COSYVOICE_MODEL_DIR:-"pretrained_models/CosyVoice-300M-SFT"}
HOST=${COSYVOICE_HOST:-"0.0.0.0"}

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "================================================================"
echo "  CosyVoice TTS Service"
echo "================================================================"
echo "  Port:      $PORT"
echo "  Host:      $HOST"
echo "  Model:     $MODEL_DIR"
echo "  Directory: $SCRIPT_DIR"
echo "================================================================"
echo ""

# Check if model directory exists
if [ ! -d "$MODEL_DIR" ]; then
    echo "❌ ERROR: Model directory not found: $MODEL_DIR"
    echo ""
    echo "Please download the model first:"
    echo ""
    echo "  python -c \""
    echo "from modelscope import snapshot_download"
    echo "snapshot_download('iic/CosyVoice2-0.5B', local_dir='$MODEL_DIR')"
    echo "\""
    echo ""
    exit 1
fi

# Check if conda environment is activated
if [ -z "$CONDA_DEFAULT_ENV" ]; then
    echo "⚠️  WARNING: Conda environment not detected"
    echo "   It's recommended to activate the cosyvoice environment:"
    echo "   conda activate cosyvoice"
    echo ""
fi

# Check if in correct directory
if [ ! -f "runtime/python/fastapi/server.py" ]; then
    echo "❌ ERROR: Must run from CosyVoice root directory"
    echo "   Current: $SCRIPT_DIR"
    exit 1
fi

echo "✅ Starting CosyVoice FastAPI server..."
echo ""

# Start the FastAPI server
cd runtime/python/fastapi
python server.py --port "$PORT" --model_dir "../../../$MODEL_DIR"

