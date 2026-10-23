package models.midnight;

/** The stages of serving one customer in Midnight Apothecary. */
enum Phase
{
	PEEK; // recipe visible, peek timer running
	BREW; // recipe hidden, patience timer running, player adds ingredients
	WAITING; // result popup / pause - nothing ticks
}
