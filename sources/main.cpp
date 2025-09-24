/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.cpp                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: adrmarqu <marvin@42.fr>                    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/09/24 16:22:48 by adrmarqu          #+#    #+#             */
/*   Updated: 2025/09/24 17:00:36 by adrmarqu         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include <iostream>
#include "../includes/ConfigFile.hpp"
#include "../includes/ServerManager.hpp"

static bool	checkNumArgs(int ac)
{
	return ac != 2;
}

int	main(int ac, char **av)
{
	if (checkNumArgs(ac))
		return std::cerr << "Wrong num of arguments --> ./webserv [file]" << std::endl, 1;
	
	try
	{
		ConfigFile		config(av[1]);
		ServerManager	server;
	}
	catch (std::exception const &e)
	{
		std::cerr << "Error: " << e.what() << std::endl;
	}
	return 0;
}
