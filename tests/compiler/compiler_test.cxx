#include <cstdint>
#include <type_traits>


static_assert(std::is_signed<char>::value, "char is not signed");


int main()
{
    return 0;
}

