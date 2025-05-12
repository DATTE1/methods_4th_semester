#include <iostream>
#include <string>
#include <map>
#include <vector>

class Divider {
public:
    virtual std::string divide(int a, int b) = 0;
};
class SimpleDivider : public Divider {
public:
    std::string divide(int a, int b) override {
        return std::to_string(a) + " поделить на " + std::to_string(b) + " равно " + std::to_string(a / b);
    }
};
class ZeroCheckDecorator : public Divider {
    Divider* divider;
public:
    ZeroCheckDecorator(Divider* d) : divider(d) {}
    
    std::string divide(int a, int b) override {
        if (b == 0) {
            throw std::invalid_argument("Division by zero!");
        }
        return divider->divide(a, b);
    }
};

class LoggingDecorator : public Divider {
    Divider* divider;
    std::vector<std::map<std::string, std::string>>& logs; // Ссылка на внешний лог
public:
    LoggingDecorator(Divider* d, std::vector<std::map<std::string, std::string>>& logStorage) 
        : divider(d), logs(logStorage) {}
    
    std::string divide(int a, int b) override {
        time_t now = time(nullptr);
        std::string timeStr = ctime(&now);
        timeStr.pop_back();

        std::string result = divider->divide(a, b);

        std::map<std::string, std::string> logEntry;
        logEntry["params"] = "(" + std::to_string(a) + ", " + std::to_string(b) + ")";
        logEntry["result"] = result;
        logEntry["date"] = timeStr;

        logs.push_back(logEntry);
        return result;
    }
};
int main() {
    std::vector<std::map<std::string, std::string>> logs;

    Divider* simpleDiv = new SimpleDivider();
    Divider* zeroCheckedDiv = new ZeroCheckDecorator(simpleDiv);
    Divider* loggedDiv = new LoggingDecorator(zeroCheckedDiv, logs);

    try {
        std::cout << loggedDiv->divide(10, 2) << std::endl;
        std::cout << loggedDiv->divide(8, 4) << std::endl;
        std::cout << loggedDiv->divide(5, 0) <<std::endl; // Выбросит исключение
    } catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
    }

    // Вывод логов
    for (const auto& log : logs) {
        std::cout << "Date: " << log.at("date") 
             << ", Params: " << log.at("params")
             << ", Result: " << log.at("result") << std::endl;
    }

    delete loggedDiv;
    delete zeroCheckedDiv;
    delete simpleDiv;
}
