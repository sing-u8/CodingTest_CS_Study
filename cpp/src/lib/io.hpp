#pragma once
#include <cstdio>
#include <cstring>

// 버퍼 기반 빠른 stdin 파서 (Java FastScanner 상당물)
class IO {
    static constexpr int BUF = 1 << 16;
    char buf[BUF];
    int  pos = 0, len = 0;

    char gc() {
        if (pos == len) {
            len = (int)fread(buf, 1, BUF, stdin);
            pos = 0;
        }
        return pos < len ? buf[pos++] : '\0';
    }

    void skipWS() {
        char c;
        while ((c = gc()) != '\0' && (c == ' ' || c == '\n' || c == '\r' || c == '\t'));
        if (pos > 0) --pos; // put back
    }

public:
    int readInt() {
        skipWS();
        bool neg = false;
        char c = gc();
        if (c == '-') { neg = true; c = gc(); }
        int v = 0;
        while (c >= '0' && c <= '9') { v = v * 10 + (c - '0'); c = gc(); }
        return neg ? -v : v;
    }

    long long readLong() {
        skipWS();
        bool neg = false;
        char c = gc();
        if (c == '-') { neg = true; c = gc(); }
        long long v = 0;
        while (c >= '0' && c <= '9') { v = v * 10 + (c - '0'); c = gc(); }
        return neg ? -v : v;
    }

    // 공백/개행 기준 단어 하나 읽기 (최대 len-1 바이트)
    int readWord(char* out, int maxLen) {
        skipWS();
        int i = 0;
        char c;
        while (i < maxLen - 1 && (c = gc()) != '\0' && c != ' ' && c != '\n' && c != '\r' && c != '\t')
            out[i++] = c;
        out[i] = '\0';
        return i;
    }

    // 개행까지 한 줄 읽기 (최대 maxLen-1 바이트)
    int readLine(char* out, int maxLen) {
        int i = 0;
        char c;
        while (i < maxLen - 1 && (c = gc()) != '\0' && c != '\n' && c != '\r')
            out[i++] = c;
        out[i] = '\0';
        return i;
    }
};
