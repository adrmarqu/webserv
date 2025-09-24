# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: adrmarqu <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/09/24 16:06:14 by adrmarqu          #+#    #+#              #
#    Updated: 2025/09/24 16:31:58 by adrmarqu         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = webserv
CC = c++
CFLAGS = -Wall -Wextra -Werror -std=c++98 -fsanitize=address
RM = rm -rf

SRC = main.cpp

MAIN_D = ./sources/
PARS_D = ./sources/parser/
SOCK_D = ./sources/socket/
SERV_D = ./sources/server/
HTTP_D = ./sources/http/

OBJ_F = ${SRC:.cpp=.o}
OBJ_D = ./objects/
OBJ = $(addprefix ${OBJ_D}, ${OBJ_F})

DEP_F = ${SRC:.cpp=.d}
DEP_D = ./dependencies/
DEP = $(addprefix ${DEP_D}, ${DEP_F})

vpath %.cpp ${MAIN_D} ${PARS_D} ${SOCK_D} ${SERV_D} ${HTTP_D}

all: ${NAME}

${NAME}: ${OBJ}
	${CC} ${CFLAGS} ${OBJ} -o ${NAME}

${OBJ_D}%.o: %.cpp Makefile | ${OBJ_D} ${DEP_D}
	${CC} ${CFLAGS} -MMD -c $< -o $@

${OBJ_D}:
	mkdir -p $@

${DEP_D}:
	mkdir -p $@

clean:
	${RM} ${OBJ_D} ${DEP_D}
	@echo "---> Deleted objects and dependencies"

fclean: clean
	${RM} ${NAME}
	@echo "---> Deleted webserv"

re: fclean all

.PHONY: al clean fclean re
