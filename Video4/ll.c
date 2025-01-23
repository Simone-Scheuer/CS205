#include <stdio.h>
#include <stdlib.h>

//gcc -Wall -g -o ll ll.c


typedef struct node_s {
    int key;
    struct node_s *next;
} node_t;

typedef struct llist_s {
    node_t *first;
    node_t *last;
} llist_t;

node_t *new_node(int);
void add_node(llist_t *, int);
void walk_list(llist_t *);
void free_list(llist_t *);

int main(void)
{
    llist_t list = {NULL, NULL};
    add_node(&list, 1);
    add_node(&list, 2);
    add_node(&list, 3);
    add_node(&list, 4);
    add_node(&list, 5);

    walk_list(&list);
    free_list(&list);


    return EXIT_SUCCESS;
}

void add_node(llist_t *list, int key)
{
    node_t *node = new_node(key);

    if (list->first == NULL) {
        list->first = list->last = node;
    }
    else {
         list->last = list->last->next = node;
    }
    
}

node_t * new_node(int key)
{
    node_t *node = malloc(sizeof(node_t));

    node->key = key;
    node->next= NULL; 

    return node;
}

void walk_list(llist_t *list)
{
    node_t *node = list->first;

    while (node != NULL) {
    printf("node: %p key: %d\n", (void *) node, node->key);
    node = node->next;
    }
}

void free_list(llist_t *list)
{
    node_t *node = list->first;
    while (node != NULL) {
        node_t *tmp = node->next;
        free(node);
        node = tmp;
    }
    list->first = list->last = NULL;
}
