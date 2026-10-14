NAME = webserv
CC = c++
CFLAGS = -Wall -Wextra -Werror -std=c++98 -fsanitize=address

SRC_CORE_D = sources/core/
SRC_HTTP_D = sources/http/
SRC_UTILS_D = sources/utils/
SRC_SOCKET_D = sources/socket/
SRC_CONFIG_D = sources/config/

SRC_CORE_F = Server.cpp ServerManager.cpp
SRC_HTTP_F = Http.cpp HttpRequest.cpp HttpResponse.cpp Libft.cpp
SRC_UTILS_F = Client.cpp ParseReqUtils.cpp
SRC_SOCKET_F = BaseSocket.cpp ConnectSocket.cpp ListenSocket.cpp
SRC_CONFIG_F = BaseConfig.cpp ParserConfig.cpp RouteConfig.cpp ServerConfig.cpp
MAIN_F = main.cpp

SRC_F = $(MAIN_F) \
         $(addprefix $(SRC_CORE_D), $(SRC_CORE_F)) \
         $(addprefix $(SRC_HTTP_D), $(SRC_HTTP_F)) \
         $(addprefix $(SRC_UTILS_D), $(SRC_UTILS_F)) \
         $(addprefix $(SRC_SOCKET_D), $(SRC_SOCKET_F)) \
         $(addprefix $(SRC_CONFIG_D), $(SRC_CONFIG_F))

OBJ_D = objects/
OBJ_F = $(notdir $(SRC_F:.cpp=.o))
OBJ = $(addprefix $(OBJ_D), $(OBJ_F))

DEP_D = dependencies/
DEP_F = $(notdir $(SRC_F:.cpp=.d))
DEP = $(addprefix $(DEP_D), $(DEP_F))

DF = \033[0;39m
RED = \033[0;31m
BRED = \033[1;31m
BBLUE = \033[1;34m
BYELLOW = \033[1;33m
BIPRPL = \033[1;95m
BCYAN = \033[1;36m
BIRED = \033[1;91m
BIGREEN = \033[1;92m
BBLACK = \033[1;30m

all: $(NAME)

$(NAME): $(OBJ_D) $(DEP_D) $(OBJ)
	@echo "$(RED)Compiling program:$(DF)"
	@echo "$(BCYAN)$(CC) $(BBLUE)$(CFLAGS) $(BIGREEN)$(OBJ_F) $(BCYAN)-o $(RED)$(NAME)$(DF)"
	@$(CC) $(CFLAGS) $(OBJ) -o $(NAME)
	@echo "$(BIGREEN)Build complete: $(NAME)$(DF)"

$(OBJ_D)%.o: sources/%.cpp
	@mkdir -p $(OBJ_D) $(DEP_D)
	@$(CC) $(CFLAGS) -MMD -MP -MF $(DEP_D)$*.d -c $< -o $@
	@echo "$(BCYAN)$(CC) $(BBLUE)$(CFLAGS) -c $(BIRED)$< $(BCYAN)-o $(BIGREEN)$@$(DF)"

$(OBJ_D)%.o: $(SRC_CORE_D)%.cpp
	@mkdir -p $(OBJ_D) $(DEP_D)
	@$(CC) $(CFLAGS) -MMD -MP -MF $(DEP_D)$*.d -c $< -o $@
	@echo "$(BCYAN)$(CC) $(BBLUE)$(CFLAGS) -c $(BIRED)$< $(BCYAN)-o $(BIGREEN)$@$(DF)"

$(OBJ_D)%.o: $(SRC_HTTP_D)%.cpp
	@mkdir -p $(OBJ_D) $(DEP_D)
	@$(CC) $(CFLAGS) -MMD -MP -MF $(DEP_D)$*.d -c $< -o $@
	@echo "$(BCYAN)$(CC) $(BBLUE)$(CFLAGS) -c $(BIRED)$< $(BCYAN)-o $(BIGREEN)$@$(DF)"

$(OBJ_D)%.o: $(SRC_UTILS_D)%.cpp
	@mkdir -p $(OBJ_D) $(DEP_D)
	@$(CC) $(CFLAGS) -MMD -MP -MF $(DEP_D)$*.d -c $< -o $@
	@echo "$(BCYAN)$(CC) $(BBLUE)$(CFLAGS) -c $(BIRED)$< $(BCYAN)-o $(BIGREEN)$@$(DF)"

$(OBJ_D)%.o: $(SRC_SOCKET_D)%.cpp
	@mkdir -p $(OBJ_D) $(DEP_D)
	@$(CC) $(CFLAGS) -MMD -MP -MF $(DEP_D)$*.d -c $< -o $@
	@echo "$(BCYAN)$(CC) $(BBLUE)$(CFLAGS) -c $(BIRED)$< $(BCYAN)-o $(BIGREEN)$@$(DF)"

$(OBJ_D)%.o: $(SRC_CONFIG_D)%.cpp
	@mkdir -p $(OBJ_D) $(DEP_D)
	@$(CC) $(CFLAGS) -MMD -MP -MF $(DEP_D)$*.d -c $< -o $@
	@echo "$(BCYAN)$(CC) $(BBLUE)$(CFLAGS) -c $(BIRED)$< $(BCYAN)-o $(BIGREEN)$@$(DF)"

$(OBJ_D):
	@mkdir -p $(OBJ_D)

$(DEP_D):
	@mkdir -p $(DEP_D)

clean:
	@rm -rf $(OBJ_D) $(DEP_D)
	@echo "$(RED)Cleaned objects and dependencies$(DF)"

fclean: clean
	@rm -rf $(NAME)
	@echo "$(RED)Cleaned executable $(NAME)$(DF)"

re: fclean all

-include $(DEP)

.PHONY: all clean fclean re
