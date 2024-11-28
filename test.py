import numpy as np
import matplotlib.pyplot as plt

# Given data
data = [64, 21, 9, 2, 1]

# Generate a power-law distribution
def power_law_distribution(k_min=1, k_max=100, exponent=-3):
    k = np.linspace(k_min, k_max, 100)
    # Unnormalized probability distribution
    P = k ** exponent
    # Normalize the distribution
    P = P / np.sum(P)
    return k, P

# Create the plot
plt.figure(figsize=(10, 6))

# Plot the given data as a scatter plot with log scales
plt.scatter(range(1, len(data) + 1), data, color='red', label='Given Data', marker='o')

# Generate and plot the power-law distribution
k, P = power_law_distribution()
plt.plot(k, P * max(data), color='blue', label='$P(k) \sim k^{-3}$ (Scaled)', linestyle='--')

# Set log scales for both axes
plt.xscale('log')
plt.yscale('log')

# Labeling
plt.xlabel('k (log scale)')
plt.ylabel('P(k) or Value (log scale)')
plt.title('Data and Power-Law Distribution Comparison')
plt.legend()
plt.grid(True, which="both", ls="-", alpha=0.2)

# Show the plot
plt.tight_layout()
plt.show()
