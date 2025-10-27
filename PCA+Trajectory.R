# install.packages(c("FactoMineR", "factoextra", "readr", "dplyr", "ggplot2"))
library(FactoMineR)
library(factoextra)
library(readr)
library(dplyr)
library(ggplot2)
df <- read_csv
meta <- df[, 1:3]  
metabolites <- df[, 4:ncol(df)]
metabolites_num <- mutate_all(metabolites, ~as.numeric(.))
stopifnot(sum(is.na(metabolites_num)) == 0) 
metabolites_log <- log1p(metabolites_num)
metabolites_scaled <- scale(metabolites_log)
res.pca <- PCA(metabolites_scaled, graph = FALSE)
meta$Time_points <- factor(meta$Time_points, 
levels = c("QC", "D0", "D1", "D2", "D3", "D7"))
scores <- as.data.frame(res.pca$ind$coord[, 1:2])
scores$Time_points <- meta$Time_points
scores_bio <- scores %>% filter(Time_points != "QC")
group_means_bio <- scores_bio %>%
  group_by(Time_points) %>%
  summarise(
    PC1_mean = mean(Dim.1),
    PC2_mean = mean(Dim.2)
  )
group_means_bio$Time_points <- factor(group_means_bio$Time_points,
                                      levels = c("D0", "D1", "D2", "D3", "D7"))
p_traj <- ggplot(group_means_bio, aes(x = PC1_mean, y = PC2_mean)) +
  geom_path(size = 1.5, color = "#E69F00",
            arrow = arrow(length = unit(0.25, "cm"), type = "closed")) +
  geom_point(aes(fill = Time_points), shape = 21, size = 6, color = "black") +
  scale_fill_brewer(palette = "Dark2") +
  theme_minimal(base_size = 16) +
  theme(
    panel.background = element_rect(fill = "transparent", color = NA),
    plot.background = element_rect(fill = "transparent", color = NA),
    panel.grid.major = element_line(color = "grey85"),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "black"),    
    axis.title = element_text(color = "black", face = "bold"),
    plot.title = element_text(color = "black", face = "bold", hjust = 0.5),
    legend.text = element_text(color = "black"),
    legend.title = element_text(color = "black")
  ) +
  labs(
    title = "Trajectory of Metabolic Profiles Across Time Points",
    x = paste0("PC1 (", round(res.pca$eig[1, 2], 1), "%)"),
    y = paste0("PC2 (", round(res.pca$eig[2, 2], 1), "%)")
  )
ggsave("PCA_Trajectory_noQC_clean.tif", p_traj, width = 10, height = 8, dpi = 1200, bg = "white")
baseline <- group_means_bio %>% filter(Time_points == "D0")
group_means_bio <- group_means_bio %>%
  mutate(distance_to_baseline = sqrt((PC1_mean - baseline$PC1_mean)^2 +
                                       (PC2_mean - baseline$PC2_mean)^2))
p_dist <- ggplot(group_means_bio, aes(x = Time_points, y = distance_to_baseline, group = 1)) +
  geom_line(color = "#E69F00", size = 1.5) +        
  geom_point(color = "#D55E00", size = 4) +         
  theme_minimal(base_size = 16) +                   
  theme(
    panel.background = element_rect(fill = "transparent", color = NA), 
    plot.background = element_rect(fill = "transparent", color = NA),
    panel.grid.major = element_line(color = "grey85"),  
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "black"),       
    axis.title = element_text(color = "black", face = "bold"), 
    plot.title = element_text(color = "black", face = "bold", hjust = 0.5)
  ) +
  labs(
    title = "Trajectory Distance from Baseline (0h)",
    x = "Time Points",
    y = "Euclidean Distance to Baseline (PC1–PC2 space)"
  )
ggsave("Trajectory_distance_plot_clean.tif", p_dist, width = 10, height = 8, dpi = 1200, bg = "white")
print(group_means_bio)