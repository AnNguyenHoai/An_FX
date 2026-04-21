# ==============================
# GRID DD CALCULATOR (UNIT FIXED)
# ==============================

pip_value = 100  # 🔥 XAUUSD Exness


def build_orders(v0, x, y, L1, L2):
    orders = []

    # ===== L1 =====
    for i in range(L1):
        d = i * x
        orders.append({"lot": v0, "distance": d})

    # ===== L2 =====
    for j in range(1, L2 + 1):
        price_j = (L1 - 1) * x + j * y

        # 🔥 FIX UNIT
        # 🔥 BE đúng tại pullback = y
        loss = sum(
            o["lot"] * (price_j - y - o["distance"]) * pip_value
            for o in orders
        )

        vj = loss / (y * pip_value)

        orders.append({"lot": vj, "distance": price_j})

    return orders


def calc_dd(orders, N):
    return sum(
        o["lot"] * (N - o["distance"]) * pip_value
        for o in orders if N > o["distance"]
    )


def find_N(K, orders):
    target = K / 4

    low = 0
    high = 50  # realistic range

    # 🔥 auto expand nếu chưa đủ
    while calc_dd(orders, high) < target:
        high *= 2

    for _ in range(60):
        mid = (low + high) / 2
        dd = calc_dd(orders, mid)

        if dd > target:
            high = mid
        else:
            low = mid

    return low


def main():
    print("===== GRID DD CALCULATOR (UNIT CORRECT) =====")

    try:
        K = float(input("Vốn (K): "))
        L1 = int(input("Số lệnh L1: "))
        L2 = int(input("Số lệnh L2: "))
        v0 = float(input("Lot ban đầu v0: "))
        x = float(input("Khoảng cách L1 (x): "))
        y = float(input("Khoảng cách L2 (y): "))

        orders = build_orders(v0, x, y, L1, L2)

        N = find_N(K, orders)
        dd = calc_dd(orders, N)

        # ===== EXTRA =====
        last_distance = orders[-1]["distance"]
        extra_move = N - last_distance

        print("\n========== RESULT ==========")
        print(f"N ≈ {N:.2f} USD")
        print(f"DD tại N = {dd:.2f} / {K/4:.2f}")

        print("\n========== AFTER LAST ORDER ==========")
        print(f"Distance lệnh cuối = {last_distance:.2f}")
        print(f"Cần đi thêm = {extra_move:.2f} USD")

        print("\n========== ORDERS ==========")
        total_lot = 0
        for i, o in enumerate(orders, 1):
            total_lot += o["lot"]
            print(f"Lệnh {i}: lot={o['lot']:.4f}, distance={o['distance']:.2f}")

        print("\n---------- SUMMARY ----------")
        print(f"Tổng lot: {total_lot:.2f}")
        print("-----------------------------")

    except Exception as e:
        print("❌ Lỗi:", e)


if __name__ == "__main__":
    main()