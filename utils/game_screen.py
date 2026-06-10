import pygame
import time

GRID_SIZE = 6
CELL_SIZE = 80
MARGIN = 5
WINDOW_SIZE = GRID_SIZE * CELL_SIZE + (GRID_SIZE + 1) * MARGIN
FPS = 10

COLOR_MAPPER = {
    "red": (255, 0, 0),
    "purple": (128, 0, 128),
    "yellow": (255, 255, 0),
    "blue": (0, 0, 255),
    "green": (0, 255, 0),
    "light_green": (0, 128, 0),
    "sky_blue": (0, 255, 255),
    "pink": (255, 192, 203),
    "gray": (128, 128, 128),
    "orange": (255, 165, 0),
}

class GameScreen:
    def __init__(self):
        pygame.init()
        
        self.screen = pygame.display.set_mode((WINDOW_SIZE, WINDOW_SIZE))
        pygame.display.set_caption("Rush Hour")
        
        self.clock = pygame.time.Clock()
        
    def __draw_grid__(self):
        self.screen.fill((255, 255, 255))
        for row in range(GRID_SIZE):
            for col in range(GRID_SIZE):
                rect = pygame.Rect(
                    MARGIN + col * (CELL_SIZE + MARGIN),
                    MARGIN + row * (CELL_SIZE + MARGIN),
                    CELL_SIZE,
                    CELL_SIZE
                )
                pygame.draw.rect(self.screen, (200, 200, 200), rect)
    
    def __draw_vehicles__(self, vehicles):
        for _, v in vehicles.items():
            x = v["x"] - 1 
            y = v["y"] - 1
            length = v["length"]
            orientation = v["orientation"]
            color = v["color"]
            
            if orientation == 'horizontal':
                width = length * CELL_SIZE + (length - 1) * MARGIN
                height = CELL_SIZE
            else:
                width = CELL_SIZE
                height = length * CELL_SIZE + (length - 1) * MARGIN

            rect = pygame.Rect(
                MARGIN + x * (CELL_SIZE + MARGIN),
                MARGIN + y * (CELL_SIZE + MARGIN),
                width,
                height
            )
            pygame.draw.rect(self.screen, COLOR_MAPPER[color], rect)
        
    def create(self, vehicles: dict, moves: list, delay = 1):
        running = True
        
        move_index = 0
        while running:
            for event in pygame.event.get():
                if event.type == pygame.QUIT:
                    running = False

                self.__draw_grid__()
                self.__draw_vehicles__(vehicles)
                pygame.display.flip()
                self.clock.tick(FPS)
                
                if move_index < len(moves):
                    _, id, direction, steps = moves[move_index]
                    print(moves[move_index])
                    v = vehicles[id]
                    if direction == "su":
                        v["y"] += steps
                    elif direction == 'giu':     # giù = verso l'alto
                        v['y'] -= steps
                    elif direction == 'destra':
                        v['x'] += steps
                    elif direction == 'sinistra':
                        v['x'] -= steps
                    
                    move_index += 1
                    time.sleep(delay)
        
        pygame.quit()
            