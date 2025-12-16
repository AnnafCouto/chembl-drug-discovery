"""
=============================================================================
PROJECT: ChEMBL Drug Discovery Analytics
SCRIPT:  generate_graphs.py
AUTHOR:  Anna Clara Couto
DATA:    Dec/2025

DESCRIPTION:
    This script acts as generator for the project data visualization, by processing
    the raw .CSV files resulting from SQL queries and provides graphical visualization.

DEPENDENCIES:
    - pandas
    - matplotlib
    - seaborn
=============================================================================
"""
# Import libraries dependencies
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
from matplotlib.ticker import FuncFormatter

# Format milions to M for better visualization
def M_format(x, pos):
    return f'{x*1e-6:.1f}M'

# Bar plot of historical count of new metabolites discovered by year of discovery
def generate_historical_graph():
    input_file = 'data/historical_evolution.csv'
    output_file = 'assets/historical_evolution.png'

    df = pd.read_csv(input_file)

    # Clean and transform
    df = df.dropna(subset=['discovery_year'])
    df = df[df['discovery_year'] >= 1970]
    df['discovery_year'] = df['discovery_year'].astype(int)

    # Plot
    fig, ax1 = plt.subplots(figsize=(12, 6))

    # Left axis (metabolites discovery count)
    sns.barplot(data=df, x='discovery_year', y='metabolites_count', color='#4c72b0', alpha=0.7, ax=ax1)
    ax1.set_ylabel('New metabolites per year', color='#4c72b0', fontsize=12, fontweight='bold')
    ax1.tick_params(axis='y', labelcolor='#4c72b0')
    ax1.set_xlabel('Discovery Year', fontsize=12, fontweight='bold')

    # x axis
    # Show only every 5 years
    years = list(range(1970, 2030, 5))
    current_labels = ax1.get_xticklabels()
    new_labels = []
    for item in current_labels:
        try:
            year = int(float(item.get_text()))
            if year in years:
                new_labels.append(str(year))
            else:
                new_labels.append('')
        except ValueError:
             new_labels.append('')
    ax1.set_xticklabels(new_labels)

    # Right axis (accumulated metabolites count)
    ax2 = ax1.twinx()
    sns.lineplot(data=df, x=ax1.get_xticks(), y='accumulated_metabolites_count', 
                 color='#c44e52', linewidth=3, marker='o', markersize=5, ax=ax2)
    
    ax2.set_ylabel('Total accumulated discovery', color='#c44e52', fontsize=12, fontweight='bold')
    ax2.tick_params(axis='y', labelcolor='#c44e52')
    
    # format millions to M
    ax2.yaxis.set_major_formatter(FuncFormatter(M_format))
    # --------------------------------------------------------

    plt.title('Historical evolution of metabolite discovery (ChEMBL)', fontsize=16, pad=20)
    plt.grid(False, axis='x') # Remove grades verticais
    plt.tight_layout()
    
    plt.savefig(output_file, dpi=300)
    plt.close()

# Plot mass distribution in daltons of metabolites in ChEMBL database with Lipinski's Ro5 (dashed line)
def generate_mass_graph():
    input_file = 'data/mass_distribution.csv'
    output_file = 'assets/mass_distribution.png'

    df = pd.read_csv(input_file)

    # Plot
    plt.figure(figsize=(14, 7))

    # Colors (Lipinski)
    col_massa = 'mass_range_start' if 'mass_range_start' in df.columns else df.columns[0]
    colors = ['#2ecc71' if x < 500 else '#95a5a6' for x in df[col_massa]]

    sns.barplot(data=df, x='bin_label', y='count', palette=colors)

    plt.title('''Molecular weight distribution (Lipinski's Ro5 compliance check)''', fontsize=16, pad=20)
    plt.xlabel('Molecular weight (Daltons)', fontsize=12, fontweight='bold')
    plt.ylabel('Frequency (count)', fontsize=12, fontweight='bold')
    plt.xticks(rotation=45, ha='right', fontsize=10)

    # Lipinski's Ro5 dashed line
    try:
        limit_idx = df[df[col_massa] == 500].index[0]
        plt.axvline(x=limit_idx - 0.5, color='#e74c3c', linestyle='--', linewidth=2.5)
        plt.text(x=limit_idx, y=df['count'].max()*0.9, s=" Lipinski's limit\n (500 Da)", 
                 color='#e74c3c', fontweight='bold', fontsize=12)
    except IndexError:
        pass

    plt.tight_layout()
    plt.savefig(output_file, dpi=300)
    plt.close()

if __name__ == "__main__":
    generate_historical_graph()
    generate_mass_graph()