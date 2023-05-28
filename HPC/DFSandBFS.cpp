#include <iostream>
#include <omp.h>
#include <queue>
struct Node {
    int value;
    Node *left;
    Node *right;

    Node(int value) : value(value), left(nullptr), right(nullptr) {}
};

void dfs(Node *root) {
    if (root == nullptr)
        return;

    std::cout << "Visited " << root->value << std::endl;

    #pragma omp task
    dfs(root->left);

    #pragma omp task
    dfs(root->right);
}
void bfs(Node *root) {
    if (root == nullptr)
        return;

    std::queue<Node*> q;
    q.push(root);

    #pragma omp parallel
    #pragma omp single
    while (!q.empty()) {
        Node *node = q.front();
        q.pop();

        std::cout << "Visited " << node->value << std::endl;

        if (node->left != nullptr) {
            #pragma omp task
            q.push(node->left);
        }

        if (node->right != nullptr) {
            #pragma omp task
            q.push(node->right);
        }
    }
}

int main() {
    // Create a sample tree for testing
    Node* root = new Node(1);
    root->left = new Node(4);
    root->right = new Node(3);
    root->left->left = new Node(6);
    root->left->right = new Node(2);
    root->right->left = new Node(6);
    root->right->right = new Node(7);
     
     std::cout<<"DFS"<<std::endl;
    #pragma omp parallel
    {
        #pragma omp single
        dfs(root);
    }
    std::cout<<"BFS"<<std::endl;
    #pragma omp parallel
    {
        #pragma omp single
        bfs(root);
    }

    return 0;
}