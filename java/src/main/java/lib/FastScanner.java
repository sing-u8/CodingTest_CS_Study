package lib;

import java.io.BufferedInputStream;
import java.io.IOException;

public final class FastScanner {
    private final BufferedInputStream in = new BufferedInputStream(System.in);
    private final byte[] buffer = new byte[1 << 16];
    private int ptr = 0, len = 0;

    private int readByte() throws IOException {
        if (ptr >= len) {
            len = in.read(buffer);
            ptr = 0;
            if (len <= 0) return -1;
        }
        return buffer[ptr++];
    }

    public String next() throws IOException {
        StringBuilder sb = new StringBuilder();
        int c;
        do {
            c = readByte();
            if (c == -1) return null;
        } while (c <= ' ');
        while (c > ' ') {
            sb.append((char) c);
            c = readByte();
        }
        return sb.toString();
    }

    public int nextInt() throws IOException {
        String s = next();
        return s == null ? Integer.MIN_VALUE : Integer.parseInt(s);
    }

    public long nextLong() throws IOException {
        String s = next();
        return s == null ? Long.MIN_VALUE : Long.parseLong(s);
    }
}

