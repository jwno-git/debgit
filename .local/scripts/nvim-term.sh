#!/bin/bash
foot --app-id=edit --title="Editing: $1" bash -c "nvim \"$1\""
